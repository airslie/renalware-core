/*
 What is this?
 This view returns rows suitable for displaying in a dropdown filter on a form, when wanting to
 filter for example patients dialysing on Mon Wed Fri (regardless of diurnal period eg AM, PM etc) or,
 more specifically, for say patients dialysing only on Mon Wed Fri AM.
 In the first case (M W F) the returned array of ids eg {1,2,3} defines which hd_schedule_definition
 we want to filter on - so again in this case, if MWF AM is id 1, MWF PM is id 2 and  MWF EVE is 3 then
 ids will be {1,2,3}.
 Here is some example output for this view:

 ids,days
"{1,2,3}",Mon Wed Fri
{1},Mon Wed Fri AM
{2},Mon Wed Fri PM
{3},Mon Wed Fri EVE
"{5,4,6}",Tue Thu Sat
{4},Tue Thu Sat AM
{5},Tue Thu Sat PM
{6},Tue Thu Sat EVE

Of note in the SQL is that have an inner sub query that unions together S1 which is unique day_text columns
(so in the example above just Mon Wed Fri and Tue Thu Sat) with S2 which is all the unique hd_schedule variations.
We then select and sort them to get them in the right order, so that the generic M W F option is just above
its M W F AM/PM/EVE variations.
*/

select
  filter.ids,
  ((filter.days_text || ' ' :: text) || upper((filter.dirunal_code) :: text)) AS days
  from (
    select
      array_agg(S1.id) AS ids,
      0 as dirunal_order,
      days_text,
      '' as dirunal_code
    from hd_schedule_definitions S1
    group by days_text
    union all
    select
        intset(S2.id :: int),
        hdpc.sort_order,
        days_text,
        hdpc.code
    from hd_schedule_definitions S2
    inner JOIN hd_diurnal_period_codes hdpc ON ((S2.diurnal_period_id = hdpc.id))
  ) filter
  order by filter.days_text, filter.dirunal_order;
