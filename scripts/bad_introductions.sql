COPY ( SELECT DISTINCT ON (opencivicdata_bill.id)
        identifier,
        title,
    LEFT (opencivicdata_bill.extras ->> 'introduction_str',
        10) AS introduction_date,
    date AS earliest_action_date,
    opencivicdata_bill.extras ->> 'matter_id' AS matter_id,
    opencivicdata_bill.extras ->> 'introduction_failure_mode' AS "problem"
FROM
    opencivicdata_bill
    LEFT JOIN opencivicdata_billaction ON bill_id = opencivicdata_bill.id
WHERE
    opencivicdata_bill.extras ->> 'introduction_failure_mode' IS NOT NULL
ORDER BY
    opencivicdata_bill.id,
    date
ORDER BY
    identifier)
TO STDOUT WITH CSV HEADER;




