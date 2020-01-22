select
  HDP.*,
  W.created_at::date as added_to_worryboard_on,
  U.username as added_to_worryboard_by
from renalware.hd_mdm_patients HDP
inner join renalware.patients P on P.id = HDP.id
inner join renalware.patient_worries W ON W.patient_id = P.id
inner join renalware.users U ON U.id = W.created_by_id;
