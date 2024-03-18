BEGIN;

CREATE TEMPORARY TABLE bill_summaries (
    filename text,
    summary text
);

COPY bill_summaries
FROM
    STDIN WITH (
        FORMAT CSV,
        HEADER);

WITH summaries as (
SELECT
    version_id, jsonb_build_object("summary", summary) as summary
FROM
    bill_summaries
    INNER JOIN opencivicdata_billversionlink ON url LIKE '%' || filename)
UPDATE opencivicdata_billversion SET extras = extras || summary
FROM summaries WHERE opencivicdata_billversion.id = version_id;


WITH summaries as (
SELECT
    bill_id, jsonb_build_object("summary", summary) as summary
FROM
    bill_summaries
    INNER JOIN opencivicdata_billversionlink ON url LIKE '%' || filename
    INNER JOIN opencivicdata_billversion ON opencivicdata_billversion.id = version_id)
UPDATE opencivicdata_bill SET extras = extras || summary
FROM summaries WHERE opencivicdata_bill.id = bill_id;

COMMIT;

