FactoryGirl.define do
  factory :hd_session, class: "Renalware::HD::Session::Open" do
    patient

    performed_on 1.week.ago
    start_time "11:00"
    notes "Some notes"
    association :hospital_unit, factory: :hospital_unit
    association :signed_on_by, factory: :user
  end

  factory :hd_dna_session, class: "Renalware::HD::Session::DNA" do
    association :patient, factory: :hd_patient
    performed_on 1.week.ago
    start_time "00:00"
    notes "Some notes"
    association :hospital_unit, factory: :hospital_unit
    association :signed_on_by, factory: :user
    association :created_by,  factory: :user
  end

  factory :hd_closed_session, class: "Renalware::HD::Session::Closed" do
    association :patient, factory: :hd_patient
    performed_on 1.week.ago
    start_time "11:00"
    end_time "16:00"
    notes "Some notes"
    association :hospital_unit, factory: :hospital_unit
    association :signed_on_by, factory: :user
    association :signed_off_by, factory: :user


  end
end
