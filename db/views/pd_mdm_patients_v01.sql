select
  distinct on (P.id)
  P.id,
  P.secure_id,
  (upper(P.family_name) || ', ' || P.given_name) as "patient_name",
  P.nhs_number,
  P.local_patient_id as hospital_numbers,
  P.sex,
  P.born_on,
  date_part('year', age(P.born_on)) as "age",
  RPROF.esrf_on,
  Mx.modality_name,
  case
    when pw.id > 0 then true
    else false
    end as on_worryboard,
  TXRSD."name" tx_status,
  case pr.type
    when 'Renalware::PD::APDRegime' then 'APD'
    when 'Renalware::PD::CAPDRegime' then 'CAPD'
    end as pd_type,
  pesi.diagnosis_date as last_esi_date,
  ppe.diagnosis_date as last_peritonitis_date,
  PA.values -> 'HGB' ->> 'result' as hgb,
  (PA.values -> 'HGB' ->> 'observed_at')::date as hgb_date,
  PA.values -> 'URE' ->> 'result' as ure,
  (PA.values -> 'URE' ->> 'observed_at')::date as ure_date,
  PA.values -> 'CRE' ->> 'result' as cre,
  (PA.values -> 'CRE' ->> 'observed_at')::date as cre_date,
  PA.values -> 'EGFR' ->> 'result' as egfr
from renalware.patients P
left join patient_worries pw on pw.patient_id  = p.id
left outer join renalware.pathology_current_observation_sets PA on PA.patient_id = P.id
left outer join renalware.renal_profiles RPROF on RPROF.patient_id = P.id
left outer join renalware.transplant_registrations TXR on TXR.patient_id = P.id
left outer join renalware.transplant_registration_statuses TXRS on TXRS.registration_id = TXR.id AND TXRS.terminated_on IS NULL
left outer join renalware.transplant_registration_status_descriptions TXRSD on TXRSD.id = TXRS.description_id
left outer join renalware.pd_regimes pr on pr.patient_id = P.id and pr.start_date <= current_date and pr.end_date is null
left outer join renalware.pd_exit_site_infections pesi on pesi.patient_id = P.id
left outer join pd_peritonitis_episodes ppe on ppe.patient_id = P.id
inner join renalware.patient_current_modalities Mx on Mx.patient_id = P.id and Mx.modality_code = 'pd'
order by P.id, pr.start_date desc, pr.created_at desc, pesi.diagnosis_date desc, ppe.diagnosis_date desc;
