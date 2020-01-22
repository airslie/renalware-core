select TP.*
from renalware.transplant_mdm_patients TP
where last_operation_date >= (now() - interval '1 year');
