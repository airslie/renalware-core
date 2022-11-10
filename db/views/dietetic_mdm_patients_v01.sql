select
  P.id,
  P.secure_id,
  (upper(P.family_name) || ', ' || P.given_name) as "patient_name",
  P.nhs_number,
  P.local_patient_id as hospital_numbers,
  P.sex,
  P.born_on,
  date_part('year', age(P.born_on)) as "age",
  Mx.modality_name,
  true as weight_management_clinic, -- TODO: needs populating - will be used as a filter dropdown to isolate a set of patients
  case when pw.id > 0 then true else false end as on_worryboard,
  (select bmi from clinic_visits where patient_id = P.id and bmi > 0 order by date desc limit 1) as bmi,
  convert_to_float(PA.values -> 'POT' ->> 'result', null) as pot,
  (PA.values -> 'POT' ->> 'observed_at')::date as pot_date,
  convert_to_float(PA.values -> 'PHOS' ->> 'result', null) as phos,
  (PA.values -> 'PHOS' ->> 'observed_at')::date as phos_date,
  '?' as sga_score, -- TODO:
  current_date  as sga_date -- TODO:
from renalware.patients P
left join patient_worries pw on pw.patient_id = p.id
left outer join renalware.pathology_current_observation_sets PA on PA.patient_id = P.id
inner join renalware.patient_current_modalities Mx on Mx.patient_id = P.id;
