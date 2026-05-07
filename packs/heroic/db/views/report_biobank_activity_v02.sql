with serum_samples as (
 select
     S.id as sample_id,
     S.patient_id,
     S.collected_at,
     age(S.collected_at, now()) as aaa,
     S.sample_type_id,
     ST.abbreviation
 from renalware_heroic.heroic_participants P
 inner join renalware_heroic.biobank_samples S on S.patient_id = P.patient_id
 inner join renalware_heroic.biobank_sample_types ST on ST.Id = sample_type_id
 where ST.abbreviation = 'SER'
),

-- now find related samples within 15 days or the serum - awful SQL needs refactoring, sorry!
related_samples as (
select
distinct on (S.patient_id, BS.sample_type_id)
    BS.id,
    S.patient_id,
    S.sample_id as parent_serum_id,
    BS.sample_type_id,
    ST."name" as sample_type_name,
    BS.collected_at,
    abs(EXTRACT(EPOCH FROM age(BS.collected_at, s.collected_at))::INTEGER) as distance_from_serum_collected_at,
    COALESCE((select count(*) from renalware_heroic.biobank_aliquots A where A.sample_id = BS.id), 0) -
        COALESCE((select count(*) from renalware_heroic.biobank_aliquots A
        inner join renalware_heroic.biobank_usages U on U.usable_id = A.id and U.usable_type = 'Renalware::Heroic::BioBank::Aliquot'
        where A.sample_id = BS.id)) as avail_aliquot_count

    from
        renalware_heroic.biobank_samples BS
        inner join renalware_heroic.biobank_sample_types ST on ST.id = BS.sample_type_id
    inner join
        serum_samples S using (patient_id)
    where
        BS.collected_at >= (S.collected_at - interval '15 days') AND  BS.collected_at<= (S.collected_at + interval '15 days')
    order by S.patient_id, BS.sample_type_id , distance_from_serum_collected_at
)

SELECT
    HP.heroic_patient_number AS "Patient HEROIC study number",
    HP.family_name AS "Surname",
    HP.given_name AS "First Name",
    SS.collected_at as "Date of Serum",
    COALESCE(( select avail_aliquot_count from related_samples RS where RS.parent_serum_id = SS.sample_Id and RS.sample_type_name = 'Serum'), 0)  as "Serum aliquot number",
    COALESCE(( select avail_aliquot_count from related_samples RS where RS.parent_serum_id = SS.sample_Id and RS.sample_type_name = 'E-PLA'), 0) as "Plasma aliquot number",
    COALESCE(( select avail_aliquot_count from related_samples RS where RS.parent_serum_id = SS.sample_Id and RS.sample_type_name = 'DNA'), 0) as "DNA aliquot number",
    COALESCE(( select avail_aliquot_count from related_samples RS where RS.parent_serum_id = SS.sample_Id and RS.sample_type_name = 'RNA'),0) as "RNA aliquot number",
    COALESCE(( select avail_aliquot_count from related_samples RS where RS.parent_serum_id = SS.sample_Id and RS.sample_type_name = 'Urine-PL'),0) as  "Urine aliquot number",
    COALESCE(( select avail_aliquot_count from related_samples RS where RS.parent_serum_id = SS.sample_Id and RS.sample_type_name = 'Urine-IN'),0) as "Urine with inhibitor aliquot number"
FROM
    renalware_heroic.heroic_participants hp
    inner join serum_samples SS on SS.patient_id = HP.patient_id
    order by HP.heroic_patient_number;
