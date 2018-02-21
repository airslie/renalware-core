/*
Returns a jsonb hash of OBX results for each day a patient had an observation.

Example output:

patient_id  observation_date  observations
------------------------------------------
1           2018-02-02        {"CYA": "14"}
1           2016-06-15        {"CMVDNA": "0.10"}
1           2016-03-15        {"NA": "137", "TP": "74", "ALB": "48", "ALP": "71", ...
1           2016-02-29        {"NA": "136", "TP": "78", "ALB": "47", "ALP": "71", ...
*/

select obs_req.patient_id, cast(observed_at as date) as observed_on,
jsonb_object_agg(obs_desc.code, obs.result) results
from pathology_observations obs
inner join pathology_observation_requests obs_req on obs.request_id = obs_req.id
inner join pathology_observation_descriptions obs_desc on obs.description_id = obs_desc.id
group by patient_id, observed_on
order by patient_id asc, observed_on desc;
