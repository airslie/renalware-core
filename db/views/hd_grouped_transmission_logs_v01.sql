-- This view puts child HD:TransmissionLogs logs next to their parent
-- e.g.
-- id, parent_id
-- 104,null
-- 105,104
-- 106,104
-- 107,null
-- 108,107
-- 109,null
-- 110,109
-- 111,109
-- ...
--
-- You can sort the view in reverse chronological order using eg
-- select * from diaverum_logs order by id desc, updated_at desc
-- The WITH RECURSIVE allows a CTE to reference itself.
-- Note also the window function OVER to allow us to generate maxlevel
-- Adapted from https://stackoverflow.com/questions/17261792/postgresql-recursive-self-join
with recursive parent_child_logs(parent_id, id, uuid, level) as (
    select t.parent_id, t.id, uuid, 1 as level
    from hd_transmission_logs t where t.parent_id is null
    union all
    select parent_child_logs.id, t.id, t.uuid, parent_child_logs.level + 1
    from hd_transmission_logs t join parent_child_logs on t.parent_id = parent_child_logs.id
    ),
    ordered_parent_child_logs as (
    select id, parent_id, level, max(level) over (partition by id) as maxlevel from parent_child_logs
    )
    SELECT h.* from ordered_parent_child_logs
    inner join hd_transmission_logs h on h.id = ordered_parent_child_logs.id
where level = maxlevel order by id asc, updated_at asc;
