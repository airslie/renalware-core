select hp.*
FROM renalware_heroic.heroic_participants hp
inner join research_participations rp on hp.participation_id = rp.id
where
   hp.withdrawal_status is null
or hp.partial_withdrawal_date is null
or hp.complete_withdrawal_date is null
or hp.consent_type is null
or hp.consent_date is null
or hp.diabetes_type is null
or hp.year_of_birth is null
or hp.sex is null
or hp.diabetes_type is null
or hp.mri_antaros_0_booked_for is null
or hp.mri_antaros_0_completed is null
or hp.mri_antaros_2_booked_for is null
or hp.mri_antaros_2_completed is null
or hp.mri_antaros_5_booked_for is null
or hp.mri_antaros_5_completed is null
or hp.biopsy_date is null
