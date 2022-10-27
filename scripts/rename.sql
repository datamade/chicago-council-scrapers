SELECT 'alter table ' || t.name || ' rename to ' || substr(t.name, 15) || ';' 
FROM sqlite_master t where name like 'opencivicdata_%';
