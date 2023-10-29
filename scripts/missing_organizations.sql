COPY (
    SELECT
        identifier,
        title,
        description AS action,
        date,
        opencivicdata_bill.extras ->> 'matter_id' AS matter_id
    FROM
        opencivicdata_billaction
        INNER JOIN opencivicdata_bill ON bill_id = opencivicdata_bill.id
    WHERE
        opencivicdata_billaction.extras ->> 'missing_organization' = 'true'
    ORDER BY
        identifier)
TO STDOUT WITH CSV HEADER;







