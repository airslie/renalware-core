WITH blood_visits_with_associated_sample_id AS (
    -- CTE takes blood_visits view and adds a vboolean to indicate if there is any sample 15 days
    -- either side of the visit date
    SELECT
        BV.*,
        exists (
            SELECT
                id
            FROM
                renalware_heroic.biobank_samples S
            WHERE
                S.patient_id = BV.patient_id
                AND daterange(
                  (visit_date::date - interval '15 days')::date,
                  (visit_date::date + interval '15 days')::date,
                  '[]'
                ) @> S.collected_at::date
            ) AS has_sample
        FROM
            renalware_heroic.blood_visits BV
),
blood_visits_having_an_associated_sample AS (
    -- A convenience CTE
    SELECT
        V.*
    FROM
        blood_visits_with_associated_sample_id V
    WHERE
        has_sample = true
)
SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    HP.blood_visit_0_date,
    exists (select BVS.has_sample from blood_visits_having_an_associated_sample BVS where BVS.visit_number = 0 and BVS.patient_id = HP.patient_id) as "BioBank Sample Taken For Visit 0",
    HP.blood_visit_1_date,
    exists(select BVS.has_sample from blood_visits_having_an_associated_sample BVS where BVS.visit_number = 1 and BVS.patient_id = HP.patient_id) as "BioBank Sample Taken For Visit 1",
    HP.blood_visit_2_date,
    exists(select BVS.has_sample from blood_visits_having_an_associated_sample BVS where BVS.visit_number = 2 and BVS.patient_id = HP.patient_id) as "BioBank Sample Taken For Visit 2",
    HP.blood_visit_3_date,
    exists(select BVS.has_sample from blood_visits_having_an_associated_sample BVS where BVS.visit_number = 3 and BVS.patient_id = HP.patient_id) as "BioBank Sample Taken For Visit 3",
    HP.blood_visit_4_date,
    exists(select BVS.has_sample from blood_visits_having_an_associated_sample BVS where BVS.visit_number = 4 and BVS.patient_id = HP.patient_id) as "BioBank Sample Taken For Visit 4",
    HP.blood_visit_5_date,
    exists(select BVS.has_sample from blood_visits_having_an_associated_sample BVS where BVS.visit_number = 5 and BVS.patient_id = HP.patient_id) as "BioBank Sample Taken For Visit 5"
FROM
    renalware_heroic.heroic_participants hp
    WHERE
        HP.active = TRUE;
