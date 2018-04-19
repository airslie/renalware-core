SELECT
  units.name,
  month,
  year,
  count(stats.id) AS patient_count,
  0 as percentage_hb_gt_100,
  0 as percentage_urr_gt_65,
  0 as percentage_phosphate_lt_1_8,
  0 as percentage_access_fistula_or_graft,
  avg(stats.dialysis_minutes_shortfall) as avg_missed_hd_time,
  avg(stats.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct) as pct_shortfall_gt_5_pct
FROM hd_patient_statistics stats
  INNER JOIN patients p on p.id = stats.patient_id
  LEFT OUTER JOIN hospital_units units ON units.id = stats.hospital_unit_id
GROUP BY units.name, year, month;
