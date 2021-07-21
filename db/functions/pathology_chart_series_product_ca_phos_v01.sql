CREATE OR REPLACE FUNCTION renalware.pathology_chart_series_product_ca_phos(pat_id integer, start_date date)
RETURNS TABLE(observed_on bigint, result float)
     LANGUAGE sql
AS $function$
    /*
     * Returns the product of calcium and phosphate for a patient where those tests appear on the same day.
     * Only take rows on or after the start_date argument.
     *  "2017-07-12" : 2.581,
     *  "2017-07-10" : 2.551,
     *  "2017-07-09" : 3.301,
     */
    with cal as (
        select distinct on (po.observed_at::date)
            po.observed_at observed_on,
            convert_to_float(po.result) as result
        from pathology_observations po
        inner join pathology_observation_requests por on por.id = po.request_id
        inner join pathology_observation_descriptions pod on pod.id = po.description_id
        where por.patient_id = pat_id and pod.code = 'CAL'
        order by po.observed_at::date desc
    ),
    phos as (
        select distinct on (po2.observed_at::date)
            po2.observed_at observed_on,
            convert_to_float(po2.result) result
        from pathology_observations po2
        inner join pathology_observation_requests por2 on por2.id = po2.request_id
        inner join pathology_observation_descriptions pod2 on pod2.id = po2.description_id
        where por2.patient_id = pat_id and pod2.code = 'PHOS'
        order by po2.observed_at::date desc
    )
    select
        extract(epoch from phos.observed_on)::bigint * 1000,
        round((phos.result * cal.result)::numeric, 3)::float
    from phos
    inner join cal on cal.observed_on = phos.observed_on
    where
        phos.result > 0
        and cal.result > 0
        and phos.observed_on >= start_date
    order by phos.observed_on asc;;
$function$;
