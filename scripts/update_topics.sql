BEGIN;

CREATE TEMP TABLE bill_topics (
    id text,
    title text,
    extras jsonb
);

COPY bill_topics
FROM
    STDIN WITH (
        FORMAT CSV,
        HEADER);

UPDATE
    opencivicdata_bill
SET
    extras = (opencivicdata_bill.extras || bill_topics.extras)
FROM
    bill_topics
WHERE
    opencivicdata_bill.id = bill_topics.id;

COMMIT;

