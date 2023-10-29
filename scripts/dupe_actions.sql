COPY ( WITH dupes AS (
        SELECT
            bill_id,
            description,
            date,
            count(*) AS number_of_times_duplicated
        FROM
            opencivicdata_billaction
        GROUP BY
            bill_id,
            description,
            date
        HAVING
            count(*) > 1
)
        SELECT
            identifier,
            description AS action,
            date,
            number_of_times_duplicated,
            opencivicdata_bill.extras ->> 'matter_id' AS matter_id
        FROM
            dupes
            INNER JOIN opencivicdata_bill ON bill_id = opencivicdata_bill.id
        WHERE
            opencivicdata_bill.extras ->> 'matter_id' IS NOT NULL
        ORDER BY
            identifier)
    TO STDOUT WITH CSV HEADER


