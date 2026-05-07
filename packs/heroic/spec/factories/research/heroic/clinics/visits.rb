# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_clinic_visit, class: "Renalware::Heroic::Clinics::Visit", parent: :clinic_visit do
    clinic factory: :heroic_clinic
    patient { Renalware::Clinics.cast_patient(create(:patient)) }
  end
end
