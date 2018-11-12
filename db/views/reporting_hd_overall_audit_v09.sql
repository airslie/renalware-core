WITH fistula_or_graft_access_types AS (
  select id from access_types where name ilike '%fistula%' or name ilike '%graft%'
)
, patients_w_fistula_or_graft as (
  select patient_id from access_profiles where type_id in (select id from  fistula_or_graft_access_types)
),
stats as (
  select
  s.patient_id,
  s.hospital_unit_id,
  s.month,
  s.year,
  s.session_count,
  s.number_of_missed_sessions,
  s.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct,
  exists(select x.patient_id from patients_w_fistula_or_graft x where x.patient_id = s.patient_id) as has_fistula_or_graft,
  ((number_of_missed_sessions::float / NULLIF(session_count::float, 0)) * 100.0) > 10.0 as missed_sessions_gt_10_pct,
  s.dialysis_minutes_shortfall::float,
  convert_to_float(s.pathology_snapshot -> 'HGB' ->> 'result') > 100 as hgb_gt_100,
  convert_to_float(s.pathology_snapshot -> 'HGB' ->> 'result') > 130 as hgb_gt_130,
  convert_to_float(s.pathology_snapshot -> 'PTHI' ->> 'result') < 300 as pth_lt_300,
  convert_to_float(s.pathology_snapshot -> 'URR' ->> 'result') > 64 as urr_gt_64,
  convert_to_float(s.pathology_snapshot -> 'URR' ->> 'result') > 69 as urr_gt_69,
  convert_to_float(s.pathology_snapshot -> 'PHOS' ->> 'result') < 1.8 as phos_lt_1_8
  from hd_patient_statistics s
  where s.rolling is null
)
select
  hu.name,
  stats.year,
  stats.month,
  count(*) as patient_count,
  round(avg(stats.dialysis_minutes_shortfall)::decimal, 2) as avg_missed_hd_time,
  round(avg(number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct),2) as pct_shortfall_gt_5_pct,
  round(((count(*) filter(where missed_sessions_gt_10_pct = true))::float / count(*)::float * 100)::decimal, 2) as pct_missed_sessions_gt_10_pct,
  round(((count(*) filter(where hgb_gt_100 = true))::float / count(*)::float * 100)::decimal, 2) as percentage_hgb_gt_100,
  round(((count(*) filter(where hgb_gt_130 = true))::float / count(*)::float * 100)::decimal, 2) as percentage_hgb_gt_130,
  round(((count(*) filter(where pth_lt_300 = true))::float / count(*)::float * 100)::decimal, 2) as percentage_pth_lt_300,
  round(((count(*) filter(where urr_gt_64 = true))::float / count(*)::float * 100)::decimal, 2) as percentage_urr_gt_64,
  round(((count(*) filter(where urr_gt_69 = true))::float / count(*)::float * 100)::decimal, 2) as percentage_urr_gt_69,
  round(((count(*) filter(where phos_lt_1_8 = true))::float / count(*)::float * 100)::decimal, 2) as percentage_phosphate_lt_1_8,
  round(((((count(*) FILTER (WHERE (stats.has_fistula_or_graft = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_access_fistula_or_graft
  from stats
inner join hospital_units hu on hu.id = stats.hospital_unit_id
group by hu.name, stats.year, stats.month
order by hu.name, stats.year asc, stats.month asc;
