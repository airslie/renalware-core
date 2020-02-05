# frozen_string_literal: true

FactoryBot.define do
  factory :access_assessment, class: "Renalware::Accesses::Assessment" do
    accountable
    association :patient, factory: :accesses_patient
    association :type, factory: :access_type
    side { :left }
    performed_on { Time.zone.now }
    document {
      {
        results: {
          method: :hand_doppler
        }
      }
    }
  end
end
