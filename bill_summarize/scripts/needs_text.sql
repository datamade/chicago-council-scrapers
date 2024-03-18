COPY (
    SELECT
        media_type,
        url
    FROM
        opencivicdata_billversionlink

        INNER JOIN opencivicdata_billversion ON opencivicdata_billversion.id = version_id
        INNER JOIN opencivicdata_bill ON opencivicdata_bill.id = bill_id
        INNER JOIN opencivicdata_legislativesession ON opencivicdata_legislativesession.id = legislative_session_id
    WHERE
        opencivicdata_legislativesession.identifier = '2023'
        AND opencivicdata_bill.extras -> 'key_legislation' = 'true'
        AND not opencivicdata_bill.extras ? 'summary')
TO STDOUT WITH CSV HEADER;



