json.nhs_number patient.nhs_number
json.secure_id patient.secure_id
json.legacy_patient_id patient.legacy_patient_id
json.local_patient_id patient.local_patient_id
json.local_patient_id_2 patient.local_patient_id_2
json.local_patient_id_3 patient.local_patient_id_3
json.local_patient_id_4 patient.local_patient_id_4
json.local_patient_id_5 patient.local_patient_id_5
json.title patient.title
json.given_name patient.given_name
json.family_name patient.family_name
json.born_on patient.born_on&.to_s
json.died_on patient.died_on&.to_s
json.sex patient.sex&.code
json.ethnicity patient.ethnicity&.code
json.medications_url api_v1_patient_medications_prescriptions_url(patient_id: patient)
json.hd_profile_url api_v1_patient_hd_current_profile_url(patient_id: patient)
