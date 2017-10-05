select
mp.*,
drug_types.code as drug_type_code,
drug_types.name as drug_type_name
from
medication_prescriptions mp
full outer join medication_prescription_terminations mpt on mpt.prescription_id = mp.id
inner join drugs on drugs.id = mp.drug_id
inner join drug_types_drugs on drug_types_drugs.drug_id = drugs.id
inner join drug_types on drug_types_drugs.drug_type_id = drug_types.id
and (mpt.terminated_on IS NULL OR mpt.terminated_on > CURRENT_TIMESTAMP)
