FactoryBot.define do
  factory :outpatient_prescription_administration_reason,
          class: "Renalware::Medications::OutpatientPrescriptionAdministrationReason" do
    sequence(:name) { |n| "Reason #{n}" }
  end
end
