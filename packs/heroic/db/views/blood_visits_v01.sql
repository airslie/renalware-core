-- A rather clumsy way of pivoting the blood_visit_0_date, blood_visit_1_date columns in the
-- research_participations.document into rows.
-- This would be easier more elegant if instead of having blood_visit_0_date, blood_visit_1_date
-- etc we stored an array of dates in the document eg blood_visit_dates[] with a max extent
-- however using Virtus and out own document implementation in renalware-core/lib/document.rb
-- we cannot currently define eg 'attribute :blood_visit_dates, Array[Date]' although this is
-- valid for Virtus. Until we solve this we will stick with the union approach here.
          SELECT patient_id, 0 as visit_number, blood_visit_0_date as visit_date from renalware_heroic.heroic_participants
union all SELECT patient_id, 1 as visit_number, blood_visit_1_date as visit_date from renalware_heroic.heroic_participants
union all SELECT patient_id, 2 as visit_number, blood_visit_2_date as visit_date from renalware_heroic.heroic_participants
union all SELECT patient_id, 3 as visit_number, blood_visit_3_date as visit_date from renalware_heroic.heroic_participants
union all SELECT patient_id, 4 as visit_number, blood_visit_4_date as visit_date from renalware_heroic.heroic_participants
union all SELECT patient_id, 5 as visit_number, blood_visit_5_date as visit_date from renalware_heroic.heroic_participants
order by patient_id, visit_number
