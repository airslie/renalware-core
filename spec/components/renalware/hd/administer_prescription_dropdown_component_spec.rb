# frozen_string_literal: true

require "rails_helper"

describe Renalware::HD::AdministerPrescriptionDropdownComponent, type: :component do
  it "renders the button title" do
    patient = Renalware::Patient.new

    render_inline(described_class.new(patient: patient))

    expect(page).to have_content("Record HD Drugs")
  end

  context "when the patient has no drugs to be given on HD" do
    it "indicates no drugs are available" do
      patient = Renalware::Patient.new

      render_inline(described_class.new(patient: patient))

      expect(page).to have_content("Patient has no drugs to be given on HD")
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

      render_inline(described_class.new(patient: patient))

      expect(page).not_to have_content("Patient has no drugs to be given on HD")

      expect(page).to have_content("Drug1")
      expect(page).to have_content("Drug2")
      expect(page).not_to have_content("Drug3")

      # Using the view_component built-in rendered_component method here
      # to inspect the html; since we are looking for data attributes,
      # its easier than digging around with page (capybara) or the return result
      # fronm render_inline (nokogiri).
      expect(rendered_component)
        .to match(new_hd_prescription_administration_path(prescriptions[0]))
      expect(rendered_component)
        .to match(new_hd_prescription_administration_path(prescriptions[1]))
      expect(rendered_component)
        .not_to match(new_hd_prescription_administration_path(prescriptions[2]))
    end
  end
  # rubocop:enable RSpec/MultipleExpectations
end
