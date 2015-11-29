-- Filename:    db_disk_usage.sql
-- Author:      Adrian Torrie
-- Date:        2015-11-22

-- Purpose:
-- --------
-- Get data regrading hard drive space used by all objects
-- in the current database connected to

-- Usage:
-- ------
--  - run statements

-- References:
-- -----------
--  Postgresql Wiki - Disk Usage
--      - https://wiki.postgresql.org/wiki/Disk_Usage

select pg_size_pretty(pg_database_size('<db-name>'))
;


-- shows the size of all the individual parts. Tables which have both regular
-- and TOAST pieces will be broken out into separate components
select
    nspname || '.' || relname as "name"
    ,relpages as page_count
    ,pg_size_pretty(pg_relation_size(c.oid)) as "size"
    ,(relpages * 8) as size_kb
    ,(relpages * 8) / 1024.0 as size_mb
    ,((relpages * 8) / 1024.0 ) / 1024.0 as size_gb
from        
    pg_class as c

    left join pg_namespace as n
        on (n.oid = c.relnamespace)
where
    nspname not in ('pg_catalog', 'information_schema')
order by
    relpages desc
;


-- sums total disk space used by the table including indexes and toasted data 
-- rather than breaking out the individual pieces
select 
    nspname || '.' || relname  as relation
    ,relpages as page_count
    ,pg_size_pretty(pg_total_relation_size(c.oid)) as relation_size_pretty
    ,pg_total_relation_size(c.oid) as relation_size
    ,pg_total_relation_size(c.oid) / 1024.0 as relation_size_kb
    ,(pg_total_relation_size(c.oid) / 1024.0) / 1024.0 as relation_size_mb
    ,((pg_total_relation_size(c.oid) / 1024.0) / 1024.0 ) / 1024.0 as relation_size_gb
from
    pg_class as c

    left join pg_namespace as n
        on (n.oid = c.relnamespace)
where
        nspname not in ('pg_catalog', 'information_schema')
    and c.relkind   <> 'i'
    and nspname     !~ '^pg_toast'
order by
    pg_total_relation_size(c.oid) desc
limit 
    20
;