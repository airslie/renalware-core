with latest_heroic_clinic_visits as(
    select distinct on (patient_id)
    patient_id,
    "date" as last_heroic_visit_date,
    document -> 'visit_number' as last_heroic_visit_number
    from clinic_visits
    where type = 'Renalware::Heroic::Clinics::Visit' and coalesce(document ->> 'visit_number', '') != ''
    order by patient_id, "date" desc
),
latest_biobank_samples as(
    select
    patient_id,
    max(collected_at) latest_serum_sample_date
    from renalware_heroic.biobank_samples S
    inner join renalware_heroic.biobank_sample_types ST on ST.id = S.sample_type_id
    where ST.abbreviation ilike 'SER'
    group by patient_id
),
last_mri_dates as (
    select
    patient_id,
    case
    when mri_antaros_0_completed = 'yes' then mri_antaros_0_booked_for::timestamp
    when mri_antaros_2_completed = 'yes' then mri_antaros_2_booked_for::timestamp
    when mri_antaros_5_completed = 'yes' then mri_antaros_5_booked_for::timestamp
    end as last_mri_date
    from renalware_heroic.heroic_participants
  )
SELECT
    HP.heroic_patient_number as "Patient HEROIC study number",
    HP.family_name as "Surname",
    HP.given_name as "First Name",
    withdrawal_status as "Status",
    CV.last_heroic_visit_number as "Last HEROIC clinic visit number",
    CV.last_heroic_visit_date as "Date of last HEROIC clinic visit",
    HP.diabetes_type as "DM Type",
    MRI.last_mri_date as "Last completed MRI date",
    SERUM.latest_serum_sample_date as "Last BioBank Serum Date",
    HP.biopsy_date as "Histology Biopsy Date",
    HP.no_biopsy as "No Biopsy"
    from renalware_heroic.heroic_participants HP
    left outer join latest_heroic_clinic_visits CV on CV.patient_id = HP.patient_id
    left outer join last_mri_dates MRI on MRI.patient_id = HP.patient_id
    left outer join latest_biobank_samples SERUM on SERUM.patient_id = HP.patient_id;
