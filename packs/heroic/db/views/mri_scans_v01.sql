SELECT
    RP.patient_id,
    0 AS scan_number, (RP.document -> 'mri_antaros_0'::text ->> 'booked_for')::TIMESTAMP AS booked_for,
    RP.document -> 'mri_antaros_0'::text ->> 'completed' AS completed,
    RP.document -> 'mri_antaros_0'::text ->> 'patient_informed' AS patient_informed,
    RP.document -> 'mri_antaros_0'::text ->> 'transport_booked' AS transport_booked
FROM
    renalware.research_participations RP
    INNER JOIN renalware_heroic.heroic_participants HP ON HP.patient_id = RP.patient_id
union all
SELECT
    RP.patient_id,
    2 AS scan_number, (RP.document -> 'mri_antaros_2'::text ->> 'booked_for')::TIMESTAMP AS booked_for,
    RP.document -> 'mri_antaros_2'::text ->> 'completed' AS completed,
    RP.document -> 'mri_antaros_2'::text ->> 'patient_informed' AS patient_informed,
    RP.document -> 'mri_antaros_2'::text ->> 'transport_booked' AS transport_booked
FROM
    renalware.research_participations RP
    INNER JOIN renalware_heroic.heroic_participants HP ON HP.patient_id = RP.patient_id
union all
SELECT
    RP.patient_id,
    5 AS scan_number, (RP.document -> 'mri_antaros_5'::text ->> 'booked_for')::TIMESTAMP AS booked_for,
    RP.document -> 'mri_antaros_5'::text ->> 'completed' AS completed,
    RP.document -> 'mri_antaros_5'::text ->> 'patient_informed' AS patient_informed,
    RP.document -> 'mri_antaros_5'::text ->> 'transport_booked' AS transport_booked
FROM renalware.research_participations RP
  INNER JOIN renalware_heroic.heroic_participants HP ON HP.patient_id = RP.patient_id
order by patient_id, scan_number
