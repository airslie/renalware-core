# frozen_string_literal: true

require "rails_helper"

# This is testing that the HD DNA nag - a combination of a sql function and an entry
# in the nag_definitions table - works as expected. We are testing both the functionality specific
# to this nag as well as general conformance to the nag 'protocol'.
describe "HD DNA nag", type: :component, caching: true do
  include PatientsSpecHelper
  include NagHelpers

  subject(:component) { described_class.new(definition: definition, patient: patient) }

  let(:described_class) { Renalware::Patients::NagComponent }
  let(:patient) { create(:hd_patient) }
  let(:definition) { create(:patient_nag_definition, :hd_dna) }

  it_behaves_like "a nag"

  context "when the patient has an HD DNA Session in the last 30 days" do
    it "has severity: medium and date: session date" do
      sessions = [
        create(:hd_dna_session, patient: patient, performed_on: 30.days.ago.to_date),
        create(:hd_dna_session, patient: patient, performed_on: 31.days.ago.to_date),
        create(:hd_session, patient: patient, performed_on: 2.days.ago.to_date, start_time: "11:00")
      ]

      nag = definition.execute_sql_function_for(patient)

      expect(nag).to have_attributes(
        severity: :medium,
        value: nil,
        date: sessions.first.performed_on
      )
    end
  end

  context "when the patient does not have an HD DNA Session in the last 30 days" do
    it "has severity: none and date: nil" do
      create(
        :hd_dna_session,
        patient: patient,
        performed_on: 33.days.ago.to_date
      )
      nag = definition.execute_sql_function_for(patient)

      expect(nag).to have_attributes(
        severity: :none,
        value: nil,
        date: nil
      )
    end
  end
end
