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

DELETE FROM opencivicdata_membership AS A USING opencivicdata_membership AS B
WHERE A.role = B.role
    AND A.person_name = B.person_name
    AND A.organization_id = B.organization_id
    AND A.start_date > B.start_date
    AND A.end_date <= B.start_date;

