COPY (
    SELECT
        identifier,
        title,
        opencivicdata_billaction.description AS action,
        opencivicdata_organization.name,
        date,
        opencivicdata_bill.extras ->> 'matter_id' AS matter_id
    FROM
        opencivicdata_bill
        INNER JOIN opencivicdata_billaction ON bill_id = opencivicdata_bill.id
        INNER JOIN opencivicdata_organization ON opencivicdata_organization.id = organization_id
        LEFT JOIN (
            SELECT
                *
            FROM
                opencivicdata_eventparticipant
                INNER JOIN opencivicdata_event ON opencivicdata_event.id = event_id) AS event ON opencivicdata_billaction.organization_id = event.organization_id
                AND substr(start_date, 1, 10) = date
                AND status != 'cancelled'
        WHERE
            event.event_id IS NULL
            AND opencivicdata_bill.extras ->> 'matter_id' IS NOT NULL
        ORDER BY
            identifier)
    TO STDOUT WITH CSV HEADER



