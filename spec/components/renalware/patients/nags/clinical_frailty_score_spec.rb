# frozen_string_literal: true

require "rails_helper"

describe "Clinical Frailty Score nag", type: :model do
  include PatientsSpecHelper

  subject(:component) do
    Renalware::Patients::NagComponent.new(definition: definition, patient: patient)
  end

  let(:patient) { create(:patient) }
  let(:definition) { create(:patient_nag_definition, :clinical_frailty_score) }

  before do
    create(:clinical_frailty_score_event_type)
  end

  # if mode is HD PD Tx and frailty is blank or more than 180days old then red, if 90-180 then
  # orangeelse blank
  context "when the patient has a Clinical Frailty Score event" do
    {
      high: [
        { modality: [:pd, :hd, :transplant], age: [281] }
      ],
      medium: [
        { modality: [:pd, :hd, :transplant], age: [91, 180] }
      ],
      none: [
        { modality: [:pd, :hd, :transplant], age: [89] },
        { modality: [:low_clearance], age: [8, 81, 91, 181] }
      ]
    }.each do |severity, groups|
      groups.each do |opts|
        ages = opts[:age]
        opts[:modality].each do |modality|
          ages.each do |age|
            context "when modality is #{modality} and age is #{age}" do
              it "severity is #{severity}" do
                set_modality(
                  patient: patient,
                  modality_description: FactoryBot.create(:"#{modality}_modality_description"),
                  by: patient.created_by
                )
                create(
                  :clinical_frailty_score,
                  patient: patient,
                  date_time: age.days.ago
                )

                nag = definition.execute_sql_function_for(patient)
                expect(nag.severity).to eq(severity)
              end
            end
          end
        end
      end
    end
  end

  context "when the patient does not have a Clinical Frailty Score event" do
    {
      high: %w(hd pd transplant),
      none: %w(low_clearance)
    }.each do |severity, modalities|
      modalities.each do |modality|
        it "returns a severity of '#{severity}' if modality is #{modality}" do
          set_modality(
            patient: patient,
            modality_description: FactoryBot.create(:"#{modality}_modality_description"),
            by: patient.created_by
          )
          expect(Renalware::Events::Event.for_patient(patient).count).to eq(0)

          nag = definition.execute_sql_function_for(patient)

          expect(nag.severity).to eq(severity)
        end
      end
    end
  end

  context "when the patient does not have a modality" do
    it "returns a severity of none" do
      nag = definition.execute_sql_function_for(patient)

      expect(nag.severity).to eq(:none)
    end
  end
end
