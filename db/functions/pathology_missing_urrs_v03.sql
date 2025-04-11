create or replace function renalware.pathology_missing_urrs(
    look_behind_hours int default 12,
    look_ahead_hours int default 4,
    post_ure_code varchar default 'P_URE',
    ure_code varchar default 'URE',
    urr_code varchar default 'URR'
)
returns table (
    suggested_urr numeric,
    post_urea_observed_at timestamp,
    post_urea_result float,
    post_urea_distance_in_hours_from_pre int,
    pre_urea_observed_at timestamp,
    pre_urea_result float,
    post_urea_request_id int,
    post_urea_observation_id int,
    post_urea_code varchar,
    pre_urea_request_id int,
    pre_urea_observation_id int,
    pre_urea_code varchar,
    patient_id int
)
as $func$
declare
start_po_id bigint;
begin

  -- only search the last 3 million (1 month?) of pathology
  select max(id) - 3000000 from renalware.pathology_observations into start_po_id;

  -- First create a temp table of non-zero URE results
  drop table if exists tmp_ure_only;
create temp table tmp_ure_only as
  select
    po.id,
    po.nresult,
    po.observed_at,
    pod.code,
    por.patient_id,
    por.id as request_id
    from renalware.pathology_observations po
    inner join renalware.pathology_observation_descriptions pod on pod.id = po.description_id
    inner join renalware.pathology_observation_requests por on por.id = po.request_id
    where po.id > start_po_id
    and pod.code = 'URE'
    and nresult > 0;

   create index tmp_ure_only_idx on tmp_ure_only using btree (patient_id);

  return query
  with obrs_with_either_one_urr_or_one_post_urea as (
      select
          por.patient_id,
          request_id, -- same for urr and p_ure so helps us find urr if exists
          count(*) as urr_p_ure_count -- number of p_ure and urr OBX in this OBR - unlikely to be anything other than 0,1,2 (2 == URR alrready generated)
      from renalware.pathology_observations po
      inner join renalware.pathology_observation_descriptions pod on pod.id = po.description_id
      inner join renalware.pathology_observation_requests por on por.id = po.request_id
      where
        po.id > start_po_id
        and pod.code in ('P_URE', 'URR')
      group by por.patient_id, request_id --observed_at::date
      having count(*) = 1 -- select only rows with either just a P_URE or just a URR. Really only the former will be found but you never know
  ),
  post_urea_with_no_urr_sibling as (
      select
          x.*,
          po.id as observation_id,
          code,
          nresult,
          observed_at
      from renalware.pathology_observations po
      inner join renalware.pathology_observation_descriptions pod on pod.id = po.description_id
      inner join obrs_with_either_one_urr_or_one_post_urea x on x.request_id = po.request_id
      where
        po.id > start_po_id
        and pod.code = 'P_URE'
        and nresult > 0
  ),
  per_and_post_urea_pairs as (
      select
          post.observed_at       as post_urea_observed_at
          ,post.nresult           as post_urea_result
          ,abs((EXTRACT(epoch from AGE(post.observed_at, pre.observed_at)) / 60 / 60 )::int) as post_urea_distance_in_hours_from_pre
          ,pre.observed_at        as pre_urea_observed_at
          ,pre.nresult            as pre_urea_result
          ,post.request_id        as post_urea_request_id
          ,post.observation_id    as post_urea_observation_id
          ,post.code              as post_urea_code
          ,pre.request_id         as pre_urea_request_id
          ,pre.id                 as pre_urea_observation_id
          ,pre.code               as pre_urea_code
          ,post.patient_id
      from post_urea_with_no_urr_sibling post
      left outer join tmp_ure_only pre on pre.patient_id = post.patient_id
      and tsrange(
          post.observed_at - '1 hour'::interval * $1,
          post.observed_at + '1 hour'::interval * $2
          ) @> pre.observed_at
  )
  select
      distinct on (x.patient_id, x.post_urea_observation_id)
      round(((x.pre_urea_result - x.post_urea_result) / x.pre_urea_result * 100)::numeric, 2) as suggested_urr,
      x.*
      from per_and_post_urea_pairs x
      order by x.patient_id, x.post_urea_observation_id, x.post_urea_distance_in_hours_from_pre asc;
end;
$func$ language plpgsql;
