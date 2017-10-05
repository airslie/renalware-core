-- Note that in the example of
-- greatest(count(cca_2_1_to_2_4), 1) we default to a 1 if count is 0 which you think
-- would ff
select
  modality_desc       modality,
  count(patient_id)   patient_count,
  round(avg(cca),2)   avg_cca,
  round(count(cca_2_1_to_2_4) / greatest(count(cca_2_1_to_2_4), 1) * 100, 2) pct_cca_2_1_to_2_4,
  round(count(pth_gt_300) / greatest(count(pth_gt_300), 1) * 100, 2)         pct_pth_gt_300,
  round(count(pth_gt_800) / greatest(count(pth_gt_800), 1) * 100, 2)         pct_pth_gt_800_pct,
  round(avg(phos),2)  avg_phos,
  max(phos)           max_phos,
  round(count(phos_lt_1_8)   / greatest(count(phos_lt_1_8),1) * 100, 2) pct_phos_lt_1_8

  from (
    select
    p.id patient_id,
    md.name modality_desc
    from patients p
    inner join modality_modalities m on m.patient_id = p.id
    inner join modality_descriptions md on m.description_id = md.id
  ) e1
  left join lateral (select result::decimal pth  from pathology_current_observations where description_code = 'PTH'  and patient_id = e1.patient_id) e2 ON true
  left join lateral (select result::decimal phos from pathology_current_observations where description_code = 'PHOS' and patient_id = e1.patient_id) e3 ON true
  left join lateral (select result::decimal cca  from pathology_current_observations where description_code = 'CCA'  and patient_id = e1.patient_id) e4 ON true
  left join lateral (select phos phos_lt_1_8 where phos < 1.8) e5 ON true
  left join lateral (select pth pth_gt_800 where pth > 800) e6 ON true
  left join lateral (select pth pth_gt_300 where pth > 300) e7 ON true
  left join lateral (select cca cca_2_1_to_2_4 where cca between 2.1 and 2.4) e8 ON true
  group by modality_desc
