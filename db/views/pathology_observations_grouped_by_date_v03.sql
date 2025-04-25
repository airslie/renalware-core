SELECT obr.patient_id,
    (obs.observed_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/London')::date AS observed_at,
    jsonb_object_agg(pod.code, ARRAY[obs.result, obs.comment::character varying] ORDER BY obs.observed_at) AS results,
    pcg2.name AS "group"
   FROM renalware.pathology_observations obs
     JOIN renalware.pathology_observation_requests obr ON obs.request_id = obr.id
     JOIN renalware.pathology_observation_descriptions pod ON obs.description_id = pod.id
     JOIN renalware.pathology_code_group_memberships pcgm2 ON pcgm2.observation_description_id = pod.id
     JOIN renalware.pathology_code_groups pcg2 ON pcg2.id = pcgm2.code_group_id
  GROUP BY pcg2.name, obr.patient_id, (obs.observed_at AT TIME ZONE 'UTC' at time zone 'Europe/London')::date
  ORDER BY obr.patient_id, pcg2.name, (obs.observed_at AT TIME ZONE 'UTC' at time zone 'Europe/London')::date DESC;
