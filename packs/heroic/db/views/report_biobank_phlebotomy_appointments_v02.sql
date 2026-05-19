-- This CTE uses distinct and order by to choose the earliest date after yesterday
WITH next_blood_visit_dates AS (
    SELECT
        DISTINCT ON (patient_id) patient_id,
        visit_date,
        visit_number
    FROM
        renalware_heroic.blood_visits
    WHERE
        visit_date::date >= now()::date
    ORDER BY
        patient_id ASC,
        visit_date ASC
)
SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    visit_date AS "Next Future Blood Tracking Date",
    visit_number AS "Next Future Blood Tracking visit number"
FROM
    renalware_heroic.heroic_participants HP
    LEFT OUTER JOIN next_blood_visit_dates BV ON BV.patient_id = HP.patient_id
WHERE
    HP.active = true
ORDER BY
    HP.patient_id
