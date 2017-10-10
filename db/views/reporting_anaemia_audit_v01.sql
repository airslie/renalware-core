select
  modality_desc       modality,
  count(e1.patient_id)   patient_count,
  round(avg(hgb),2)    avg_hgb,
  round(count(hgb_gt_eq_10) / greatest(count(hgb), 1.0) * 100.0, 2) pct_hgb_gt_eq_10,
  round(count(hgb_gt_eq_11) / greatest(count(hgb), 1.0) * 100.0, 2) pct_hgb_gt_eq_11,
  round(count(hgb_gt_eq_13) / greatest(count(hgb), 1.0) * 100.0, 2) pct_hgb_gt_eq_13,
  round(avg(fer),2) avg_fer,
  round(count(fer_gt_eq_150) / greatest(count(fer), 1.0) * 100.0, 2) pct_fer_gt_eq_150,
  count(epo_drug) no_on_epo,
  count(mircer_drug) count_mircer,
  count(neo_drug) count_neo,
  count(ara_drug) count_ara
  from (
    select
    p.id patient_id,
    md.name modality_desc
    from patients p
    inner join modality_modalities m on m.patient_id = p.id
    inner join modality_descriptions md on m.description_id = md.id
    where m.ended_on is null or m.ended_on > current_timestamp
  ) e1
  left join lateral (select result::decimal hgb from pathology_current_observations where description_code = 'HGB' and patient_id = e1.patient_id) e2 ON true
  left join lateral (select result::decimal fer from pathology_current_observations where description_code = 'FER' and patient_id = e1.patient_id) e3 ON true
  left join lateral (select hgb hgb_gt_eq_10 where hgb >= 10) e4 ON true
  left join lateral (select hgb hgb_gt_eq_11 where hgb >= 11) e5 ON true
  left join lateral (select hgb hgb_gt_eq_13 where hgb >= 13) e6 ON true
  left join lateral (select fer fer_gt_eq_150 where fer >= 150) e7 ON true
  left join lateral (
    select mcp.id as prescription_id, mcp.drug_type_code, mcp.drug_name as drug_name from medication_current_prescriptions mcp
    where mcp.patient_id = e1.patient_id) e8 ON true
  left join lateral (select drug_name epo_drug where drug_type_code = 'immunosuppressant') e9 ON true
  left join lateral (select drug_name mircer_drug where drug_name like 'Mircer%') e10 ON true
  left join lateral (select drug_name neo_drug where drug_name like 'Neo%') e11 ON true
  left join lateral (select drug_name ara_drug where drug_name like 'Ara%') e12 ON true
  where modality_desc in ('HD','PD','Transplant', 'LCC', 'Nephrology')
 group by modality_desc
