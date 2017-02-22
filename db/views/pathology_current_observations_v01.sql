-- The order by ensures that the most recently observed result is at the top, and because we use
-- DISTINCT on patient_id and description_id, this means we only get the most recent of each
-- observation. Note that the view only contains rows were there is an observation; for example
-- if there has never been a recorded HGB value for patient_id 1 then no NULL HGB row is returned.
SELECT DISTINCT ON (pathology_observation_requests.patient_id, pathology_observation_descriptions.id)
    pathology_observations.id,
    pathology_observations.result,
    pathology_observations.comment,
    pathology_observations.observed_at,
    pathology_observations.description_id,
    pathology_observations.request_id,
    pathology_observation_descriptions.code AS description_code,
    pathology_observation_descriptions.name AS description_name,
    pathology_observation_requests.patient_id
   FROM pathology_observations
     LEFT JOIN pathology_observation_requests ON pathology_observations.request_id = pathology_observation_requests.id
     LEFT JOIN pathology_observation_descriptions ON pathology_observations.description_id = pathology_observation_descriptions.id
  ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;
