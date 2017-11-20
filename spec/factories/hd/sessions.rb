FactoryBot.define do
  factory :hd_session, class: "Renalware::HD::Session::Open" do
    accountable
    association :patient, factory: :hd_patient
    association :hospital_unit, factory: :hospital_unit
    association :dialysate, factory: :hd_dialysate

    signed_on_by { accountable_actor }

    performed_on { 1.week.ago }
    notes "Some notes"

    factory :hd_open_session do
      start_time "11:00"
    end

    factory :hd_dna_session, class: "Renalware::HD::Session::DNA" do
      document {
        {
          patient_on_holiday: "yes"
        }
      }
    end

    factory :hd_closed_session, class: "Renalware::HD::Session::Closed" do
      start_time "11:00"
      end_time "16:00"
      signed_off_at { 1.day.ago }
      signed_off_by { accountable_actor }

      after(:build) do |session|
        session.document = build(:hd_session_document).marshal_dump
      end
    end
  end
end
