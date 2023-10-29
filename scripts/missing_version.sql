COPY (
    SELECT
        identifier,
        title,
        opencivicdata_bill.extras ->> 'matter_id' AS matter_id
    FROM
        opencivicdata_bill
    LEFT JOIN opencivicdata_billversion ON bill_id = opencivicdata_bill.id
WHERE
    bill_id IS NULL
    AND opencivicdata_bill.extras ->> 'matter_id' IS NOT NULL
    AND classification != ARRAY['claim']
ORDER BY
    identifier)
TO STDOUT WITH CSV HEADER;



