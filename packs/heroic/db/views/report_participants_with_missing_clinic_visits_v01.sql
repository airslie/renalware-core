-- Report 16

-- Take all SER samples for Heroic participants and add some date columns
-- to represent the window within which we will search for a corresponding
-- clinic visit
WITH participant_samples AS (
    SELECT
        HP.participation_id,
        S.collected_at::date AS serum_collected_at,
        (S.collected_at - INTERVAL '15 days')::date AS date_window_start,
        (S.collected_at + INTERVAL '15 days')::date AS date_window_end,
        S.id AS sample_id
    FROM
        heroic_participants HP
    INNER JOIN biobank_samples S USING (patient_id)
        INNER JOIN biobank_sample_types ST ON ST.id = S.sample_type_id
        WHERE
            ST.abbreviation = 'SER')
-- Now list only samples where we cannot find a corresponding visit within
-- 15 days either side of the serum collectd date
SELECT
    DISTINCT ON (SP.participation_id, SP.sample_id)
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    SP.serum_collected_at AS "Serum date"
FROM
    participant_samples SP
    INNER JOIN heroic_participants HP USING (participation_id)
    WHERE
        NOT EXISTS (
            SELECT
                id
            FROM
                heroic_clinic_visits CV
            WHERE
                date BETWEEN SP.date_window_start
                AND SP.date_window_end)
        ORDER BY
            SP.participation_id,
            SP.sample_id
;
