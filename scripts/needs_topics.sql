COPY (
    SELECT
        id,
        title
    FROM
        opencivicdata_bill
    WHERE
        NOT extras ? 'topics')
TO STDOUT WITH CSV HEADER;



