CREATE OR REPLACE FUNCTION patient_nag_clinical_frailty_score(
    p_id integer,
    out out_severity system_nag_severity, -- eg 'high'
    out out_value text, -- eg a score etc like '7' or 'normal' etc
    out out_date date -- eg a date
)
AS $$
declare
    event_age_in_days integer;
    modality_code text;
begin
    --,to_char(date_time, 'DD-Mon-YYYY') || coalesce(( ' : ' || (document ->> 'score')), '')
    select into
        event_age_in_days
        , out_date
        , out_value
        days_between(e.date_time, current_timestamp::timestamp)
        ,date_time
        ,document ->> 'score'

    from events e
    inner join event_types et on et.id = e.event_type_id
    where e.patient_id  = p_id and et.slug = 'clinical_frailty_score'
    order by e.date_time desc
    limit 1;

    select into modality_code
        pcm.modality_code
    from patient_current_modalities pcm
    where pcm.patient_id = p_id;

    select into out_severity
        case
            when modality_code is NULL then 'none'
            when modality_code not in ('pd', 'hd', 'transplant') then 'none'
            when event_age_in_days is NULL then 'high' -- missing CSF event
            else
                case
                    when event_age_in_days > 180 then 'high'
                    when event_age_in_days >= 90 then 'medium'
                    else 'none'
                end
            end;
 end
$$
LANGUAGE plpgsql
STABLE;
