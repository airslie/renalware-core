WITH echo_events as (
    SELECT
      patient_id,
      CAST(document ->> 'visit_number' as INTEGER) as visit_number,
      date_time
    from events
    where type = 'Renalware::Heroic::Events::Echo'
),
participant_echo_summary as (
    SELECT
    patient_id,
    (case when HP.no_biopsy = 'true' THEN HP.no_biopsy_date ELSE HP.biopsy_date END)::date as effective_biopsy_date,
    case when exists(select patient_id from echo_events where patient_id = HP.patient_id and visit_number = 0) THEN 'N' ELSE 'Y' END as echo_0_missing,
    case when exists(select patient_id from echo_events where patient_id = HP.patient_id and visit_number = 1) THEN 'N' ELSE 'Y' END as echo_1_missing,
    case when exists(select patient_id from echo_events where patient_id = HP.patient_id and visit_number = 3) THEN 'N' ELSE 'Y' END as echo_3_missing
    FROM renalware_heroic.heroic_participants hp
    WHERE HP.active = TRUE
)
SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    M.effective_biopsy_date,
    M.echo_0_missing as "echo 0 missing",
    CASE WHEN (M.effective_biopsy_date + interval '356 days') > now() THEN M.echo_1_missing ELSE 'N' END as "echo 1 missing", -- ie > 365 days ago
    CASE WHEN (M.effective_biopsy_date + interval '1095 days') < now() OR now() > '2024-01-01' THEN M.echo_3_missing ELSE 'N' END as "echo 3 missing"
   FROM
    renalware_heroic.heroic_participants HP
    inner join participant_echo_summary M on M.patient_id = HP.patient_id
    WHERE HP.active = TRUE;
