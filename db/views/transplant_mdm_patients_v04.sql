SELECT p.id,
    p.secure_id,
    (upper(p.family_name::text) || ', '::text) || p.given_name::text AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    rprof.esrf_on,
    latest_op.performed_on AS last_operation_date,
    date_part('year'::text, age(p.born_on::timestamp with time zone))::integer AS age,
    mx.modality_name,
    case when pw.id > 0 then 'Y' else 'N' end as on_worryboard,
    (select bmi from clinic_visits cv2 where cv2.patient_id = P.id and bmi > 0 order by date desc limit 1) as bmi,
    case when latest_op.performed_on >= (now() - interval '3 months') then true else false end as tx_in_past_3m,
    case when latest_op.performed_on >= (now() - interval '12 months') then true else false end as tx_in_past_12m,
    txrsd.name AS tx_status,
    (pa."values" -> 'HGB'::text) ->> 'result'::text AS hgb,
    ((pa."values" -> 'HGB'::text) ->> 'observed_at'::text)::date AS hgb_date,
    (pa."values" -> 'URE'::text) ->> 'result'::text AS ure,
    ((pa."values" -> 'URE'::text) ->> 'observed_at'::text)::date AS ure_date,
    (pa."values" -> 'CRE'::text) ->> 'result'::text AS cre,
    ((pa."values" -> 'CRE'::text) ->> 'observed_at'::text)::date AS cre_date,
    (pa."values" -> 'EGFR'::text) ->> 'result'::text AS egfr_on,
    (named_nurses.family_name::text || ', '::text) || named_nurses.given_name::text AS named_nurse,
    (named_consultants.family_name::text || ', '::text) || named_consultants.given_name::text AS named_consultant,
    H.name AS hospital_centre
   FROM patients p
     JOIN patient_current_modalities mx ON mx.patient_id = p.id AND mx.modality_code::text = 'transplant'::text
     LEFT JOIN pathology_current_observation_sets pa ON pa.patient_id = p.id
     LEFT join patient_worries pw on pw.patient_id  = p.id
     LEFT JOIN transplant_registrations txr ON txr.patient_id = p.id
     LEFT JOIN transplant_registration_statuses txrs ON txrs.registration_id = txr.id AND txrs.terminated_on IS NULL
     LEFT JOIN transplant_registration_status_descriptions txrsd ON txrsd.id = txrs.description_id
     LEFT JOIN renal_profiles rprof ON rprof.patient_id = p.id
     LEFT JOIN users named_nurses ON named_nurses.id = p.named_nurse_id
     LEFT JOIN users named_consultants ON named_consultants.id = p.named_consultant_id
     LEFT JOIN hospital_centres H ON H.id = P.hospital_centre_id
     LEFT JOIN ( SELECT DISTINCT ON (transplant_recipient_operations.patient_id) transplant_recipient_operations.id,
            transplant_recipient_operations.patient_id,
            transplant_recipient_operations.performed_on,
            transplant_recipient_operations.theatre_case_start_time,
            transplant_recipient_operations.donor_kidney_removed_from_ice_at,
            transplant_recipient_operations.operation_type,
            transplant_recipient_operations.hospital_centre_id,
            transplant_recipient_operations.kidney_perfused_with_blood_at,
            transplant_recipient_operations.cold_ischaemic_time,
            transplant_recipient_operations.warm_ischaemic_time,
            transplant_recipient_operations.notes,
            transplant_recipient_operations.document,
            transplant_recipient_operations.created_at,
            transplant_recipient_operations.updated_at
           FROM transplant_recipient_operations
          ORDER BY transplant_recipient_operations.patient_id, transplant_recipient_operations.performed_on DESC) latest_op ON latest_op.patient_id = p.id;
