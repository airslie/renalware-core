SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    HP.withdrawal_status AS "Status",
    MRI.booked_for AS "Date of missed or next due scan",
    MRI.scan_number AS "MRI scan number",
    MRI.completed AS "Completed",
    MRI.patient_informed AS "Patient informed text",
    MRI.transport_booked AS "Transport booked text"
FROM
    renalware_heroic.heroic_participants HP
    INNER JOIN renalware_heroic.mri_scans MRI ON MRI.patient_id = HP.patient_id
    WHERE
        HP.withdrawal_status NOT IN ('3_complete_withdrawal', '4_inactive')
        AND (coalesce(MRI.completed, '') = ''
            OR MRI.booked_for >= now())
    ORDER BY
        HP.patient_id,
        MRI.scan_number;
