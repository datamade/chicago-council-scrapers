
.PHONY: updated_summaries_db
update_summaries_db: summaries.csv
	cat $< | psql $$DATABASE_URL -c "`cat scripts/update_summaries.sql`"

summaries.csv :
	- snakemake -s summarize.smk --cores 8 --keep-going 
	python scripts/create_summary_csv.py summaries/*.summary > $@

