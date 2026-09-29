 UPDATE
    opencivicdata_membership AS A
SET
    end_date = B.end_date
FROM
    opencivicdata_membership AS B
WHERE
    A.end_date != '' and B.start_date != ''
    AND A.end_date::date = B.start_date::date - 1
    AND A.role = B.role
    AND A.organization_id = B.organization_id
    AND A.person_name = B.person_name;

-- if the latest scraped term ends earlier than the merged term containing it
-- (e.g. an alder left office early), pull the merged term's end date back
UPDATE
    opencivicdata_membership AS A
SET
    end_date = B.end_date
FROM
    opencivicdata_membership AS B
WHERE A.role = B.role
    AND A.person_name = B.person_name
    AND A.organization_id = B.organization_id
    AND B.start_date > A.start_date
    AND B.end_date != ''
    AND B.end_date < A.end_date
    AND NOT EXISTS (
        SELECT 1 FROM opencivicdata_membership AS C
        WHERE C.role = B.role
            AND C.person_name = B.person_name
            AND C.organization_id = B.organization_id
            AND C.start_date > B.start_date);

DELETE FROM opencivicdata_membership AS A USING opencivicdata_membership AS B
WHERE A.role = B.role
    AND A.person_name = B.person_name
    AND A.organization_id = B.organization_id
    AND A.start_date > B.start_date
    AND A.end_date <= B.end_date;

-- nobody stays on a committee after leaving council
UPDATE
    opencivicdata_membership AS M
SET
    end_date = CC.end_date
FROM
    opencivicdata_organization AS O,
    (SELECT m.person_id, max(m.end_date) AS end_date
     FROM opencivicdata_membership AS m
     JOIN opencivicdata_organization AS o ON o.id = m.organization_id
     WHERE o.name = 'Chicago City Council'
     GROUP BY m.person_id
     -- skip anyone with an open-ended council term
     HAVING bool_and(m.end_date != '')) AS CC
WHERE O.id = M.organization_id
    AND O.classification = 'committee'
    AND M.person_id = CC.person_id
    AND CC.end_date < current_date::text
    AND M.end_date > CC.end_date;
