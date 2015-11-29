-- Filename:    function_drop_overloaded_signatures.sql
-- Author:      Adrian Torrie
-- Date:        2015-11-29

-- Purpose:
-- --------
-- Generate drop statements to get rid of the same
-- named function that has different argument signatures

-- Usage:
-- ------
--  - change the where cluase to have the schema-less name of the function
--  - comment out last line if no results are returned

-- References:
-- -----------
--  DROP FUNCTION without knowing the number/type of parameters?
--      - http://stackoverflow.com/a/7623246/893766

select
    format('drop function %s(%s);'
    ,oid::regproc
    ,pg_get_function_identity_arguments(oid))
from
    pg_proc
where
        proname = 'my_function_name'    -- name without schema-qualification
    and pg_function_is_visible(oid)     -- restrict to current search_path ..
;                                       -- .. you may or may not want this
