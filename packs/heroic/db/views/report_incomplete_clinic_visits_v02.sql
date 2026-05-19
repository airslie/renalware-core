with visits_with_key_fields as (
    select
        CV.id,
        CV.patient_id,
        CV."date" as visit_date,
        CV.visit_number,
        document -> 'health_status' ->> 'mobility' as health_status_mobility,
        document -> 'smoking' ->> 'history' as smoking_history,
        document -> 'alcohol' ->> 'history'  as alcohol_history
    from heroic_clinic_visits CV
)
select
     HP.heroic_patient_number AS "Patient HEROIC study number",
     HP.family_name AS "Surname",
     HP.given_name AS "First Name",
     HP.withdrawal_status AS "Status",
     K.visit_number as "HEROIC clinic visit number",
     K.visit_date as "Date of HEROIC clinic visit",
     CASE WHEN K.health_status_mobility IS NULL THEN 'null' ELSE '' END as health_status_mobility,
     CASE WHEN K.smoking_history IS NULL THEN 'null' ELSE '' END as smoking_history,
     CASE WHEN K.alcohol_history IS NULL THEN 'null' ELSE '' END as alcohol_history
     from visits_with_key_fields K
     inner join heroic_participants HP using (patient_id)
     where
        K.health_status_mobility is null
        or K.smoking_history is null
        or K.alcohol_history is null
     order by HP.patient_id, K.visit_number;
