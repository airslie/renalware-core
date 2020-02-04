# frozen_string_literal: true

require "rails_helper"

describe Renalware::HD::AdministerPrescriptionDropdownComponent, type: :component do
  it "renders the button title" do
    patient = Renalware::Patient.new

    html = render_inline(described_class, patient: patient).to_html

    expect(html).to match "Record HD Drugs"
  end

  context "when the patient has no drugs to be given on HD" do
    it "indicates no drugs are available" do
      patient = Renalware::Patient.new

      html = render_inline(described_class, patient: patient).to_html

      expect(html).to match "Patient has no drugs to be given on HD"
    end
  end

  # rubocop:disable RSpec/MultipleExpectations
  context "when the patient has drugs to be given on HD" do
    it "there are dropdown buttons for each drug, linking to the correct location" do
      patient = create(:hd_patient)
      prescriptions = { Drug1: true, Drug2: true, Drug3: false }.map do |drug_name, give_on_hd|
        create(
          :prescription,
          patient: patient,
          administer_on_hd: give_on_hd,
          drug: create(:drug, name: drug_name)
        )
      end

      html = render_inline(described_class, patient: patient).to_html

      expect(html).not_to match("Patient has no drugs to be given on HD")

      expect(html).to match("Drug1")
      expect(html).to match("Drug2")
      expect(html).not_to match("Drug3")

      expect(html).to match(new_hd_prescription_administration_path(prescriptions[0]))
      expect(html).to match(new_hd_prescription_administration_path(prescriptions[1]))
      expect(html).not_to match(new_hd_prescription_administration_path(prescriptions[2]))
    end
  end
  # rubocop:enable RSpec/MultipleExpectations
end
