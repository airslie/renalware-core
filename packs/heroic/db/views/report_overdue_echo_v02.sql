with tmp_events as (
    SELECT
        id,
        events.patient_id, ((events.document ->> 'visit_number'::text))::integer AS visit_number,
        events.date_time
    FROM
        events
    WHERE ((events.type)::text = 'Renalware::Heroic::Events::Echo'::text)
    AND deleted_at IS NULL
), missing_events1 as (
    SELECT
    hp.patient_id,
    (CASE WHEN hp.no_biopsy = 'true'::text THEN hp.no_biopsy_date ELSE hp.biopsy_date END)::date as effective_biopsy_date,
    (SELECT e.id FROM tmp_events e WHERE ((e.patient_id = hp.patient_id) AND (e.visit_number = 0)) LIMIT 1) as event_0_id,
    (SELECT e.id FROM tmp_events e WHERE ((e.patient_id = hp.patient_id) AND (e.visit_number = 1)) LIMIT 1) as event_1_id,
    (SELECT e.id FROM tmp_events e WHERE ((e.patient_id = hp.patient_id) AND (e.visit_number = 2)) LIMIT 1) as event_2_id
    from heroic_participants hp where hp.active = true
), missing_events2 as (
    SELECT
    *,
    (effective_biopsy_date::date + 356 < now()::date) as effective_biopsy_date_was_more_than_365_days_ago,
    (effective_biopsy_date::date + 1095 < now()::date) as effective_biopsy_date_was_more_than_1095_days_ago
    from missing_events1
)
SELECT
    hp.heroic_patient_number AS "Patient HEROIC study number",
    hp.family_name AS "Surname",
    hp.given_name AS "First Name",
    effective_biopsy_date,
    case when event_0_id is null then 'Y' else 'N' END as echo_0_missing,
    case when event_1_id is null and effective_biopsy_date_was_more_than_365_days_ago = true then 'Y' else 'N' END as echo_1_missing,
    case when event_2_id is null and effective_biopsy_date_was_more_than_1095_days_ago = true then 'Y' else 'N' END as echo_2_missing
    from missing_events2
    inner join heroic_participants HP using (patient_id);
