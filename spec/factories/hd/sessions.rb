FactoryGirl.define do
  factory :hd_session, class: "Renalware::HD::Session::Open" do
    association :patient, factory: :hd_patient
    association :hospital_unit, factory: :hospital_unit
    association :signed_on_by, factory: :user
    association :created_by, factory: :user

    performed_on 1.week.ago
    notes "Some notes"

    factory :hd_open_session do
      start_time "11:00"
    end

    factory :hd_dna_session, class: "Renalware::HD::Session::DNA" do
    end

    factory :hd_closed_session, class: "Renalware::HD::Session::Closed" do
      start_time "11:00"
      end_time "16:00"
      signed_off_at 1.day.ago
      association :signed_off_by, factory: :user

      after(:build) do |session|
        session.document = build(:hd_session_document).marshal_dump
      end
    end
  end
end
