# frozen_string_literal: true

FactoryBot.define do
  factory :access_needling_assessment, class: "Renalware::Accesses::NeedlingAssessment" do
    accountable
    association :patient, factory: :accesses_patient
    difficulty { "moderate" }
  end
end
