select
  patients.id as patient_id,
  patients.secure_id as patient_secure_id,
  current_modality.id as modality_id,
  modality_descriptions.id as modality_description_id,
  modality_descriptions.name as modality_name,
  current_modality.started_on as started_on
from patients
  -- this join only required as currently there can be > 1 current modality for a patient
  -- here we select the current modality with the most recent started_on
  left outer join (
    select distinct on (patient_id) * from modality_modalities
    order by patient_id, started_on desc
) as current_modality
on patients.id = current_modality.patient_id
left outer join modality_descriptions on modality_descriptions.id = current_modality.description_id;
