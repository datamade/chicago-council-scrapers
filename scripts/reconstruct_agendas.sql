BEGIN;

DELETE FROM opencivicdata_eventrelatedentity
WHERE agenda_item_id IN (
        SELECT
            id
        FROM
            opencivicdata_eventagendaitem
        WHERE
            extras ->> 'inferred' = 'true');

DELETE FROM opencivicdata_eventagendaitem
WHERE extras ->> 'inferred' = 'true';

INSERT INTO opencivicdata_eventagendaitem
SELECT
    gen_random_uuid (),
    title,
    ARRAY[]::text[],
    ROW_NUMBER() OVER (PARTITION BY opencivicdata_event.id ORDER BY identifier) - 1 AS "order",
    ARRAY[]::text[],
    ARRAY[]::text[],
    opencivicdata_event.id,
    jsonb_build_object('bill_id', opencivicdata_bill.id, 'bill_identifier', identifier, 'inferred', TRUE)
FROM
    opencivicdata_event
    INNER JOIN opencivicdata_eventparticipant ON opencivicdata_event.id = opencivicdata_eventparticipant.event_id
    INNER JOIN opencivicdata_billaction USING (organization_id)
    INNER JOIN opencivicdata_bill ON bill_id = opencivicdata_bill.id
    LEFT JOIN opencivicdata_eventagendaitem ON opencivicdata_event.id = opencivicdata_eventagendaitem.event_id
WHERE
    opencivicdata_eventagendaitem.id IS NULL
    AND substr(start_date, 1, 10) = date;
       
INSERT INTO opencivicdata_eventrelatedentity
SELECT
    gen_random_uuid (),
    extras ->> 'bill_identifier',
    'bill',
    'consideration',
    id,
    extras ->> 'bill_id',
    NULL,
    NULL,
    NULL
FROM
    opencivicdata_eventagendaitem
WHERE
    extras ->> 'inferred' = 'true';

UPDATE
    opencivicdata_eventagendaitem
SET
    extras = jsonb_build_object('inferred', TRUE)
WHERE
    extras ->> 'inferred' = 'true';

UPDATE
    opencivicdata_event
SET
    extras = jsonb_set(extras, '{inferred_agenda}', 'true'::jsonb)
WHERE
    opencivicdata_event.id IN (
        SELECT
            event_id
        FROM
            opencivicdata_eventagendaitem
        WHERE
            extras ->> 'inferred' = 'true');

END;

