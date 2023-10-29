
data_issues.xlsx : missing_organization_on_actions.csv missing_bill_text_pdfs.csv bad_introductions.csv dupe_actions.csv bad_action_date.csv bad_agenda_action.csv
	foo

missing_organization_on_actions.csv :
	psql $$DATABASE_URL -f scripts/missing_organizations.sql > $@

missing_bill_text_pdfs.csv :
	psql $$DATABASE_URL -f scripts/missing_version.sql > $@

bad_introductions.csv :
	psql $$DATABASE_URL -f scripts/bad_introductions.sql > $@

dupe_actions.csv :
	psql $$DATABASE_URL -f scripts/dupe_actions.sql > $@

bad_action_date.csv :
	psql $$DATABASE_URL -f scripts/bad_action_date.sql > $@

bad_agenda_action.csv :
	psql $$DATABASE_URL -f scripts/bad_agenda_action.sql > $@
