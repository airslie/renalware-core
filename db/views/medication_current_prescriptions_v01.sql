 SELECT mp.id,
    mp.patient_id,
    mp.drug_id,
    mp.treatable_type,
    mp.treatable_id,
    mp.dose_amount,
    mp.dose_unit,
    mp.medication_route_id,
    mp.route_description,
    mp.frequency,
    mp.notes,
    mp.prescribed_on,
    mp.provider,
    mp.created_at,
    mp.updated_at,
    mp.created_by_id,
    mp.updated_by_id,
    mp.administer_on_hd,
    mp.last_delivery_date,
    drugs.name as drug_name,
    drug_types.code AS drug_type_code,
    drug_types.name AS drug_type_name
   FROM medication_prescriptions mp
     FULL JOIN medication_prescription_terminations mpt ON mpt.prescription_id = mp.id
     JOIN drugs ON drugs.id = mp.drug_id
     FULL JOIN drug_types_drugs ON drug_types_drugs.drug_id = drugs.id
     FULL JOIN drug_types ON drug_types_drugs.drug_type_id = drug_types.id
      AND (mpt.terminated_on IS NULL OR mpt.terminated_on > now());
