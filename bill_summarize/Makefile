SNAKE_CORES=1

.PHONY: all
all : update_summaries_db summaries.csv

.PHONY: updated_summaries_db
update_summaries_db: new_summaries.csv
	cat $< | psql $$DATABASE_URL -c "`cat scripts/update_summaries.sql`"

summaries.csv : new_summaries.csv
	python scripts/update_summaries.py $@ $< > $@ 

new_summaries.csv : 
	- snakemake --cores $(SNAKE_CORES) --keep-going 
	python scripts/create_summary_csv.py summaries/*.summary > $@

