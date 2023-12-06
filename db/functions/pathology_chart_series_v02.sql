CREATE OR REPLACE FUNCTION renalware.pathology_chart_series(patient_id integer, observation_description_id integer, start_date date)
  RETURNS TABLE(observed_on bigint, result float)
  LANGUAGE sql
AS $function$
  /*
  Note that we use convert_to_float(result, NULL) here rather than nresult
  (same value, populated by a trigger). Explain-analysing the query shows that using nresult in the
  where clause is much slower (x10 times). This might be because pg has not optimised around
  for the use of nresult yet, but its safer for now to use convert_to_float in both places.
  */
  select
    extract(epoch from observed_at)::bigint * 1000,
    convert_to_float(result, NULL) from pathology_observations po
  inner join pathology_observation_requests por on por.id = po.request_id
  inner join pathology_observation_descriptions pod on pod.id = po.description_id
  where
    pod.id = observation_description_id
    and observed_at >= start_date
    and por.patient_id = $1
    and convert_to_float(result, NULL) is not null
  order by
    po.observed_at asc,
    po.created_at desc
$function$;
