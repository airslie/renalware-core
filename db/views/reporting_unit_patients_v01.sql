-- A CTE to define a date range to use, going back 10 years and
-- being careful to include all twelve months in the earliest year ie if we are in July 2020, go back to Jan 2010
-- by using  date_trunc('year', ...)
with date_range as (
  select date_trunc('year', current_timestamp - interval '10 years') as start
  ,current_timestamp as stop
),
-- Now calculate how far to go back in months eg 130
 month_range as (
   select
   0 as current_month,
   extract('year' from age(date_range.start)) * 12 + extract(month from age(date_range.start)) as months_to_go_back from date_range
),
-- A CTE which generates a month value starting at 0 (the current month) and going back 10 years
 months as (
  select generate_series(current_month, months_to_go_back::integer) as month from month_range
),
-- A CTE which grabs the hosp unit and the start and end months of the hd_profile
-- We use this in a bit to join onto months
profile_history as (
  select
    hp.patient_id,
    hp.hospital_unit_id,
    extract('year' from age(created_at)) * 12 + extract(month from age(created_at)) as start_month,
    coalesce(extract('year' from age(deactivated_at)) * 12 + extract(month from age(deactivated_at)), 0) as end_month -- NB if profile is current, use 0 as end month ie the current month
  from hd_profiles hp order by patient_id
),
-- remove duplicate profiles where a profile was edited to change eg the schedule within the same month bit the unit did not change
deduplicated_profile_history as (
  select distinct on (patient_id, hospital_unit_id, start_month, end_month) *
  from profile_history order by patient_id, hospital_unit_id, start_month, end_month
),
-- Count the patients in each unit/month where a patient was dialysing there but grouping and a count().
-- Note the join condition is true if the month falls on or between the profile start and end month
-- so if an HD profile spans 3 months it would generate 3 rows
patient_counts as (
  select
    ph.hospital_unit_id
    ,m.month
    ,count(*) as patients -- the number of profiles in this unit/month combination
    from deduplicated_profile_history ph
    inner join months m on m.month <= ph.start_month and m.month >= ph.end_month -- important!
    group by ph.hospital_unit_id, m.month
    order by ph.hospital_unit_id, m.month
)
-- Finally build a crosstab/matrix of units and months, and fill in patient counts for each combination where we have them
select
  hc.name as hospital
  ,hu.name as unit
  ,extract(year from current_date - (m.month::text || ' month')::interval)::text as year -- eg 2020
  ,to_char(current_date - (m.month::text || ' month')::interval, 'Mon') as month -- the abbreviated month eg Nov
  ,pc.patients as patients
  from hospital_units hu
  inner join hospital_centres hc on hc.id = hu.hospital_centre_id
  inner join months m on 1 = 1
  left outer join patient_counts pc on pc.month = m.month and pc.hospital_unit_id = hu.id
  order by hu.name, m.month;
