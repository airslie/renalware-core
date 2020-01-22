select
  P.id,
  P.secure_id,
  (upper(P.family_name) || ', ' || P.given_name) as patient_name,
  P.nhs_number,
  P.local_patient_id as hospital_numbers,
  P.sex,
  P.born_on,
  RPROF.esrf_on,
  LATEST_OP.performed_on as last_operation_date ,
  date_part('year', age(P.born_on))::int as "age",
  Mx.modality_name,
  TXRSD."name" tx_status,
  PA.values -> 'HGB' ->> 'result' as hgb,
  (PA.values -> 'HGB' ->> 'observed_at')::date as hgb_date,
  PA.values -> 'URE' ->> 'result' as ure,
  (PA.values -> 'URE' ->> 'observed_at')::date as ure_date,
  PA.values -> 'CRE' ->> 'result' as cre,
  (PA.values -> 'CRE' ->> 'observed_at')::date as cre_date,
  PA.values -> 'EGFR' ->> 'result' as egfr_on
from renalware.patients P
inner join renalware.patient_current_modalities Mx on Mx.patient_id = P.id and Mx.modality_code = 'transplant'
left outer join renalware.pathology_current_observation_sets PA on PA.patient_id = P.id
left outer join renalware.transplant_registrations TXR on TXR.patient_id = P.id
left outer join renalware.transplant_registration_statuses TXRS on TXRS.registration_id = TXR.id AND TXRS.terminated_on IS NULL
left outer join renalware.transplant_registration_status_descriptions TXRSD on TXRSD.id = TXRS.description_id
left outer join renalware.renal_profiles RPROF on RPROF.patient_id = P.id
left outer join (select distinct on (patient_id) * from renalware.transplant_recipient_operations order by patient_id, performed_on desc) LATEST_OP
on LATEST_OP.patient_id = P.id;
