/* Returns a table of date => result for a patient, obx code (eg HGB) and start date */
CREATE OR REPLACE FUNCTION renalware.pathology_chart_data(patient_id integer, code text, start_date date)
 RETURNS TABLE(observed_on date, result float)
 LANGUAGE sql
AS $function$
   SELECT observed_at::date, convert_to_float(result) from pathology_observations po
   inner join pathology_observation_requests por on por.id = po.request_id
   inner join pathology_observation_descriptions pod on pod.id = po.description_id
   where pod.code = $2 and observed_at >= start_date
and por.patient_id = $1;
$function$
;
