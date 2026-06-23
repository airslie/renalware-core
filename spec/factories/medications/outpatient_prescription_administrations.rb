FactoryBot.define do
  factory :outpatient_prescription_administration,
          class: "Renalware::Medications::OutpatientPrescriptionAdministration" do
    accountable
    prescription { association(:prescription, give_as_outpatient: true) }
    patient { prescription.patient }
    administered_by factory: :user
    skip_administrator_validation { true }
    witnessed_by factory: :user
    skip_witness_validation { true }
    administered { true }
    notes { "some notes" }
    deleted_at { nil }
    recorded_on { Time.zone.today }
  end
end
