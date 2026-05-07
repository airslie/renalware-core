SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    HP.withdrawal_status AS "Status",
    MRI.scan_number AS "MRI scan number",
    MRI.booked_for AS "Date of completed scan"
FROM
    renalware_heroic.heroic_participants HP
    INNER JOIN renalware_heroic.mri_scans MRI ON MRI.patient_id = HP.patient_id
    WHERE
        MRI.completed = 'yes'
    ORDER BY
        HP.patient_id,
        MRI.scan_number
