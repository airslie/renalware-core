#
#  observation_request_descriptions
#
#  | id | code | name               | required_observation_description_id | duration |
#  | 25 | RET  | RETICULOCYTE COUNT | 1347                                | 14       |
#
#  | id                                  | 1            | 2 | 3 |
#  | code                                | RET          |   |   |
#  | name                                | RETICULOCYTE |   |   |
#  | required_observation_description_id | RETP         |   |   |
#  | duration                            | 14           |   |   |
#  | crs_name                            | Retics       |   |   |
#  | lab                                 | Haem         |   |   |
#  | sample_type                         | EDTA         |   |   |
#
#Printing:
#
#  1. Crs Printing
#    - List crs_name GROUP BY lab
#
#  2. Manual forms
#    - List crs_name GROUP BY lab, sample_type
#    - 2 request groups per A4
#
#  For 1&2: Print patient specific tests as manual forms (one test per form, no grouping, 2 forms per A4)
#
#On print form preview (editable, then print => creates observation_request):
#  Date: Today (not editable)
#  Contact: (Clinic/modality: Nephrology/HD/PD) - editable
#  Consultant: (which consultant for the clinic) - editable
#  Number: Consultant's # - editable
#
#High Risk:
#  if
#    HepB sAg true or null
#    or
#    HepC Ab true or null
#    or
#    HIV Ab true
#
#-------------------------------------
#
#lab:
#Biochem
#Micro
#Immunology
#Virology
#Histopath
#Transpl.Lab
#
#sample_type:
#Fl
#Serrum/Plasma
#Citrate
#Urine
#PD Fluid
#
