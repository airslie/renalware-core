CREATE OR REPLACE FUNCTION renalware.patient_nag_hd_dna(
  p_id integer,
  OUT out_severity system_nag_severity,
  OUT out_value text,
  OUT out_date date
)
 RETURNS record
 LANGUAGE plpgsql
 STABLE
AS $function$
begin
  /* A nag function which is used in the UI to display a nag on patient ages if a patient has had
  * an HD DNA Session (DNA = did not attend) in the last 30 days.
  *
  * Returns:
  * - out_severity - 'medium' if the patient DNA'd in the last 30 days, otherwise 'none'
  * - out_value - a message
  * - out_date - the HD DNA Session date
  */
  with dna as (
    select distinct on (patient_id)
      patient_id
      ,'medium' as severity
      ,null as value
      ,performed_on
      from hd_sessions hds
      where type = 'Renalware::HD::Session::DNA'
        and days_between(hds.performed_on, current_timestamp::timestamp) <= 31
      order by patient_id, hds.performed_on desc
  )
  select
    into out_severity, out_value, out_date
    coalesce(dna.severity, 'none'), dna.value, dna.performed_on
  from patients p left outer join dna on dna.patient_id = p.id
  where p.id = p_id;
 end
$function$
;
