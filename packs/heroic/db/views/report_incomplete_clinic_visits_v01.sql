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
),
visits_with_missing_key_fields as (
    select
    *,
    jsonb_build_object(
        'health_status_mobility', health_status_mobility,
        'smoking_history', smoking_history,
        'alcohol_history', alcohol_history
    ) as missing_data
    from visits_with_key_fields
    where
        health_status_mobility is null
        or smoking_history is null
        or alcohol_history is null
 )
 select
     HP.heroic_patient_number AS "Patient HEROIC study number",
     HP.family_name AS "Surname",
     HP.given_name AS "First Name",
     HP.withdrawal_status AS "Status",
     K.visit_number as "HEROIC clinic visit number",
     K.visit_date as "Date of HEROIC clinic visit",
     K.missing_data as "Missing Key Data"
     from visits_with_missing_key_fields K
     inner join heroic_participants HP using (patient_id)
     order by HP.patient_id, K.visit_number
;
