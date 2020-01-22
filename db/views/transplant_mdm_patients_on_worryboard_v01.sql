select
  TP.*,
  W.created_at::date as added_to_worryboard_on,
  U.username as added_to_worryboard_by
from renalware.transplant_mdm_patients TP
inner join renalware.patients P on P.id = TP.id
inner join renalware.patient_worries W ON W.patient_id = P.id
inner join renalware.users U ON U.id = W.created_by_id
