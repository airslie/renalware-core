-- Halted on this one to allow some diffuse thinking to throw up a solution...

-- Start by finding the serum sample
with serum_samples as (
 select
     S.id as sample_id,
     S.patient_id,
     S.collected_at,
     ST.abbreviation
 from renalware_heroic.heroic_participants P
 inner join renalware_heroic.biobank_samples S on S.patient_id = P.patient_id
 inner join renalware_heroic.biobank_sample_types ST on ST.Id = sample_type_id
 where ST.abbreviation = 'SER'
),
-- then we want to select all other samples +- 15 days of the sample date
patients_with_a_sample as (
 select distinct S.patient_id
 from renalware_heroic.heroic_participants P
 inner join renalware_heroic.biobank_samples S on S.patient_id = P.patient_id
)

SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    SS.collected_at as "Date of Serum",
    0 as "Serum Aliquot number",
    0 as "Plasma Aliquot number",
    0 as "DNA Aliquot number",
    0 as "RNA Aliquot number",
    0 as "Urine_Aliquot number",
    0 as "Urine with inhibitor_Aliquot number"

FROM
    renalware_heroic.heroic_participants hp
    inner join patients_with_a_sample PS on PS.patient_id = HP.patient_id
    inner join serum_samples SS on SS.patient_id = HP.patient_id
    order by HP.heroic_patient_number

--    rabbit SER 12.12.2001
--    rabbit DNA 15.12.2001
--    rabbit RNA 10.12.2001
-- ;
-- with x as (
-- select
-- S.id as sample_id,
-- S.patient_id,
-- S.collected_at,
-- ST.abbreviation as sample_type,
-- (select count(*) from renalware_heroic.biobank_aliquots A
-- inner join renalware_heroic.biobank_usages U on U.usable_id = A.id and U.usable_type like '%Aliquot'
--  where A.sample_id = S.id) as used_aliquots
-- from renalware_heroic.biobank_samples S
-- inner join renalware_heroic.biobank_sample_types ST on ST.Id = sample_type_id
-- )
-- select * from x;
