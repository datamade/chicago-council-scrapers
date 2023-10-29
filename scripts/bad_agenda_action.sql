COPY (
    SELECT
        opencivicdata_event.name AS body,
        substr(start_date, 1, 10) AS event_date,
        opencivicdata_eventagendaitem."order" AS agenda_item_order,
        identifier,
        title,
        opencivicdata_bill.extras ->> 'matter_id' AS matter_id
    FROM
        opencivicdata_event
        INNER JOIN opencivicdata_eventparticipant ON opencivicdata_event.id = opencivicdata_eventparticipant.event_id
            AND organization_id IS NOT NULL
        INNER JOIN opencivicdata_eventagendaitem ON opencivicdata_event.id = opencivicdata_eventagendaitem.event_id
        INNER JOIN opencivicdata_eventrelatedentity ON opencivicdata_eventagendaitem.id = agenda_item_id
            AND bill_id IS NOT NULL
        INNER JOIN opencivicdata_bill ON opencivicdata_eventrelatedentity.bill_id = opencivicdata_bill.id
        LEFT JOIN opencivicdata_billaction ON opencivicdata_eventparticipant.organization_id = opencivicdata_billaction.organization_id
            AND substr(start_date, 1, 10) = date
            AND opencivicdata_eventrelatedentity.bill_id = opencivicdata_billaction.bill_id
    WHERE
        opencivicdata_bill.extras ->> 'matter_id' IS NOT NULL
        AND opencivicdata_billaction.id IS NULL
        AND status = 'passed'
    ORDER BY
        body,
        event_date,
        agenda_item_order)
TO STDOUT WITH CSV HEADER


 



