
with pd_patients as (
SELECT
  patients.id from patients
  inner join modality_modalities current_modality on current_modality.patient_id = patients.id
  inner join modality_descriptions current_modality_description
       on current_modality_description.id = current_modality.description_id
       where current_modality.ended_on is null
  and current_modality.started_on <= current_date
  and current_modality_description.name = 'PD'
),
current_regimes as(
  select * from pd_regimes where start_date >= current_date AND end_date is null
),
current_apd_regimes as(
  select * from current_regimes where type like '%::APD%'
),
current_capd_regimes as(
  select * from current_regimes where type like '%::CAPD%'
)
select 'APD' pd_type, count(patient_id) as patient_count, 0 as avg_hgb, 0 as pct_hgb_gt_100, 0 as pct_on_epo,
 0 as pct_pth_gt_500, 0 as pct_phosphate_gt_1_8, 0 as pct_strong_medium_bag_gt_1l from current_apd_regimes
union all
select 'CAPD', count(patient_id), 0, 0, 0, 0, 0, 0 from current_capd_regimes
union all
select 'PD', count(id), 0, 0, 0, 0, 0, 0 from pd_patients
