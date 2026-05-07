with participants_with_a_clinic_visit_0 AS(
  select distinct on (patient_id)
    patient_id
    from clinic_visits
    where type = 'Renalware::Heroic::Clinics::Visit' and document ->> 'visit_number' = '0'
    order by patient_id, "date" desc
),
patients_to_exclude as (
  -- No need to report if a (patient is Inactive or Withdrawn AND does not have a HEROIC Clinic visit "0")
  select
    HP.patient_id
  FROM renalware_heroic.heroic_participants HP
  left join participants_with_a_clinic_visit_0 CV0 on CV0.patient_id = HP.patient_id
  where (CV0.patient_id IS NULL AND HP.withdrawal_status in ('3_complete_withdrawal', '4_inactive'))
)
SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    HP.withdrawal_status AS "Status",
    HP.diabetes_type AS "DM Type",
    HP.mri_antaros_0_booked_for AS "MRI_0 date",
    HP.mri_antaros_0_booked_for AS "MRI_2 date",
    HP.mri_antaros_0_booked_for AS "MRI_5 date",
    HP.biopsy_date AS "Histology Biopsy Date",
    HP.no_biopsy_date AS "No Histology Biopsy Decision Date",
    HP.no_biopsy AS "No Biopsy"

FROM renalware_heroic.heroic_participants HP
where HP.patient_id not in (select patient_id from patients_to_exclude)
AND (HP.partial_withdrawal_date IS NULL
    OR HP.complete_withdrawal_date IS NULL
    OR HP.consent_type IS NULL
    OR HP.consent_date IS NULL
    OR HP.diabetes_type IS NULL
    OR HP.year_of_birth IS NULL
    OR HP.sex IS NULL
    OR HP.diabetes_type IS NULL
    OR HP.mri_antaros_0_booked_for IS NULL
    OR HP.mri_antaros_0_completed IS NULL
    OR HP.mri_antaros_2_booked_for IS NULL
    OR HP.mri_antaros_2_completed IS NULL
    OR HP.mri_antaros_5_booked_for IS NULL
    OR HP.mri_antaros_5_completed IS NULL
    OR HP.biopsy_date IS NULL);
