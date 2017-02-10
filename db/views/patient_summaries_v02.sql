SELECT
patients.id as patient_id,
(SELECT COUNT(*) FROM "events" WHERE "events"."patient_id" = patients.id) as events_count,
(SELECT COUNT(*) FROM "clinic_visits" WHERE "clinic_visits"."patient_id" = patients.id) as clinic_visits_count,
(SELECT COUNT(*) FROM "letter_letters" WHERE "letter_letters"."patient_id" = patients.id) as letters_count,
(SELECT COUNT(*) FROM "access_profiles" WHERE "access_profiles"."patient_id" = patients.id) as access_profiles_count,
(SELECT COUNT(*) FROM "modality_modalities" WHERE "modality_modalities"."patient_id" = patients.id) as modalities_count,
(SELECT COUNT(*) FROM "problem_problems" WHERE "problem_problems"."deleted_at" IS NULL AND "problem_problems"."patient_id" = patients.id) as problems_count,
(SELECT COUNT(*) FROM "pathology_observation_requests" WHERE "pathology_observation_requests"."patient_id" = patients.id) as observation_requests_count,
(SELECT COUNT(*) FROM "medication_prescriptions" WHERE "medication_prescriptions"."patient_id" = patients.id) as prescriptions_count,
(SELECT COUNT(*) FROM "letter_contacts" WHERE "letter_contacts"."patient_id" = patients.id) as contacts_count
FROM patients
