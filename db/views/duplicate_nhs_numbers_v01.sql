select
  p.secure_id,
  p.nhs_number,
  (upper(P.family_name) || ', ' || P.given_name) as "patient_name",
  p.created_at,
  p.updated_at
from renalware.patients p
inner join (
  select nhs_number, count(*) from renalware.patients group by nhs_number having count(*) > 1
) t using(nhs_number);
