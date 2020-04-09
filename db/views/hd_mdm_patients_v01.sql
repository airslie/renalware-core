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
  AT.name as access,
  AP.started_on as access_date,
  APLANTYPE.name as access_plan,
  APLAN.created_at::date as plan_date,
  TXRSD."name" tx_status,
  UNIT.name as hospital_unit,
  UNIT.unit_code as dialysing_at,
  (named_nurses.family_name::text || ', '::text) || named_nurses.given_name::text AS named_nurse,
  (HDP.document -> 'transport' ->> 'has_transport'::text) || ': ' || (HDP.document -> 'transport' ->> 'type'::text) as transport,
  (SCHED.days_text || ' ' || UPPER(DIURNAL.code)) as schedule,
  PA.values -> 'HGB' ->> 'result' as hgb,
  (PA.values -> 'HGB' ->> 'observed_at')::date as hgb_date,
  PA.values -> 'PHOS' ->> 'result' as phos,
  (PA.values -> 'PHOS' ->> 'observed_at')::date as phos_date,
  PA.values -> 'POT' ->> 'result' as pot,
  (PA.values -> 'POT' ->> 'observed_at')::date as pot_date,
  PA.values -> 'PTHI' ->> 'result' as pthi,
  (PA.values -> 'PTHI' ->> 'observed_at')::date as pthi_date,
  PA.values -> 'URR' ->> 'result' as urr,
  (PA.values -> 'URR' ->> 'observed_at')::date as urr_date
from renalware.patients P
inner join renalware.patient_current_modalities Mx on Mx.patient_id = P.id and Mx.modality_code = 'hd'
left outer join renalware.hd_profiles HDP on HDP.patient_id = P.id and HDP.deactivated_at is null
left outer join renalware.hospital_units UNIT on UNIT.id = HDP.hospital_unit_id
LEFT JOIN users as named_nurses ON named_nurses.id = hdp.named_nurse_id
left outer join renalware.hd_schedule_definitions SCHED on SCHED.id = HDP.schedule_definition_id
left outer join renalware.hd_diurnal_period_codes DIURNAL on DIURNAL.id = SCHED.diurnal_period_id
left outer join renalware.pathology_current_observation_sets PA on PA.patient_id = P.id
left outer join (select distinct on (patient_id) * from renalware.access_profiles where terminated_on is null order by patient_id, created_at desc) AP ON AP.patient_id = P.id
left outer join renalware.access_types AT on AT.id = AP.type_id
left outer join renalware.access_plans APLAN on APLAN.patient_id = P.id and APLAN.terminated_at is null
left outer join renalware.access_plan_types APLANTYPE on APLANTYPE.id = APLAN.plan_type_id
left outer join renalware.transplant_registrations TXR on TXR.patient_id = P.id
left outer join renalware.transplant_registration_statuses TXRS on TXRS.registration_id = TXR.id AND TXRS.terminated_on IS NULL
left outer join renalware.transplant_registration_status_descriptions TXRSD on TXRSD.id = TXRS.description_id
left outer join renalware.renal_profiles RPROF on RPROF.patient_id = P.id
left outer join (select distinct on (patient_id) patient_id, performed_on from renalware.transplant_recipient_operations order by patient_id, performed_on desc) LATEST_OP
on LATEST_OP.patient_id = P.id;
