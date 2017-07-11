/*
As we already have an hd_patient_statistics table that updates (in the background)
whenever something amount an HD Session changes, here we can query that table.
WHoever given what I know about auditing now I wonder of that hd_patient_statistics table
should be the materialized view itself, and we remove the Ruby code (AuditableSessionCollection
etc) and move that logic (mainly summing and averaging) in the the view
*/
SELECT
units.name,
count(stats.id) as patient_count,
ROUND(AVG(stats.pre_mean_systolic_blood_pressure)) as mean_pre_systolic_blood_pressure,
ROUND(AVG(stats.pre_mean_diastolic_blood_pressure)) as mean_pre_diastolic_blood_pressure,
ROUND(AVG(stats.post_mean_systolic_blood_pressure)) as mean_post_systolic_blood_pressure,
ROUND(AVG(stats.post_mean_diastolic_blood_pressure)) as mean_post_diastolic_blood_pressure,
ROUND(AVG(stats.mean_fluid_removal),2) as mean_fluid_removal,
ROUND(AVG(stats.mean_weight_loss),2) as mean_weight_loss,
ROUND(AVG(stats.mean_machine_ktv),2) as mean_machine_ktv,
ROUND(AVG(stats.mean_blood_flow),2) as mean_blood_flow,
ROUND(AVG(stats.mean_litres_processed),2) as mean_litres_processed
from hd_patient_statistics as stats
inner join hospital_units as units on units.id = stats.hospital_unit_id
group by units.name

