-- A helper view to aggregate Heroic Clinic Visits
select
  *,
  (document ->> 'visit_number')::integer as visit_number
  from clinic_visits CV
  where type = 'Renalware::Heroic::Clinics::Visit';
