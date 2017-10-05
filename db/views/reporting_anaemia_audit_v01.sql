select
  modality_desc       modality,
  count(patient_id)   patient_count,
  round(avg(hb),2)    avg_hb,
  round(count(hb_gt_eq_10) / greatest(count(hb), 1.0) * 100.0, 2) pct_hb_gt_eq_10,
  round(count(hb_gt_eq_11) / greatest(count(hb), 1.0) * 100.0, 2) pct_hb_gt_eq_11,
  round(count(hb_gt_eq_13) / greatest(count(hb), 1.0) * 100.0, 2) pct_hb_gt_eq_13,
  round(avg(fer),2)   avg_fer,
  round(count(fer_gt_eq_150) / greatest(count(fer), 1.0) * 100.0, 2) pct_fer_gt_eq_150
  from (
    select
    p.id patient_id,
    md.name modality_desc
    from patients p
    inner join modality_modalities m on m.patient_id = p.id
    inner join modality_descriptions md on m.description_id = md.id
  ) e1
  left join lateral (select result::decimal hb from pathology_current_observations where description_code = 'HB' and patient_id = e1.patient_id) e2 ON true
  left join lateral (select result::decimal fer from pathology_current_observations where description_code = 'FER' and patient_id = e1.patient_id) e3 ON true
  left join lateral (select hb hb_gt_eq_10 where hb >= 10) e4 ON true
  left join lateral (select hb hb_gt_eq_11 where hb >= 11) e5 ON true
  left join lateral (select hb hb_gt_eq_13 where hb >= 13) e6 ON true
  left join lateral (select fer fer_gt_eq_150 where fer >= 150) e7 ON true
  where modality_desc in ('HD','PD','Transplant', 'LCC', 'Nephrology')
  group by modality_desc
