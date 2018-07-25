-- Returns rows like this for use in filtering lists of HD Patients
-- by extact schedule (eg Mon Wed Fri AM) or the day only (Mon We Fri).
-- This solution allow for adding other combinations eg Wed Fri Sun etc
-- and the filters will automatically display this combination as an option.
-- ids,days_text
-- {1,2,3},"Mon Wed Fri"
-- {3},"Mon Wed Fri AM"
-- ..
-- {4,5,6},"Tue Thu Sat"
-- {2},"Mon Wed Fri PM"
-- ...

select *
from
  (
    (select
       array_agg(s.id) as ids,
       days_text       as days
     from hd_schedule_definitions s
     group by days_text)

    union

    (select
       array_agg(s.id)                      as ids,
       days_text || ' ' || upper(hdpc.code) as days
     from hd_schedule_definitions s
       inner join hd_diurnal_period_codes hdpc on s.diurnal_period_id = hdpc.id
     group by s.id, hdpc.code
    )
  ) t
order by t.ids :: text;
