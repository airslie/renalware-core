create or replace function renalware.pathology_resolve_observation_description(
  obx_code varchar, -- e.g. 'CREA'
  site varchar  -- e.g. RAJ01
)
/*
 * Given an OBX code eg 'CREAT' and a site eg 'RAJ01' (aka SOH), we look in
 * pathology_obx_mappings to see if the supplied code is an 'alias' at the site, in which
 * case we return the mapped pathology_obx_mappings.observation_description; otherwise
 * we return the direct match (if there is one) in observation_descriptions.
 * OBX mapping allows disparate sites to converge
 * results into the same test code even if it is known by different codes locally.
 * For example for RAJ01 CREAT might map to CRE.
 * If the code we are passed matches both obx_mappings.code_alias and observation_descriptions.code
 * then we return the observation_description that the mapping points to. This allows a site to redefine
 * an existing code.
 */
RETURNS integer as
  $body$
  begin
    RETURN (
        select distinct on (pod.id) pod.id
        from pathology_observation_descriptions pod
        left outer join pathology_obx_mappings pom on pom.observation_description_id = pod.id
        left outer join pathology_senders ps on ps.id = pom.sender_id
        where
        (
            pom.code_alias = obx_code and site similar to ps.sending_facility
        )
        OR
        (
            pod.code = obx_code
        )
        order by pod.id asc, pom.observation_description_id
        limit 1
    );
end
  $body$
 LANGUAGE plpgsql;
