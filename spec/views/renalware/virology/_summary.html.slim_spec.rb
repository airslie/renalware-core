# frozen_string_literal: true

require "rails_helper"

describe "renalware/virology/summary", type: :view do
  VIROLOGY_ATTRIBUTES = %i(hiv hepatitis_b hepatitis_c).freeze
  helper(Renalware::AttributeNameHelper)

  let(:patient) { build_stubbed(:patient) }
  let(:partial) { "renalware/virology/summary" }

  context "when the patient has no HIV, HepB or HEPC in their clinical profile" do
    it "displays an empty Virology section" do
      render partial: partial, locals: { patient: patient }

      VIROLOGY_ATTRIBUTES.each do |virology_attribute|
        expect(rendered).not_to include(human_virology_attribute_name_for(virology_attribute))
      end
    end
  end

  def human_virology_attribute_name_for(attr_name)
    attr_name(patient.document, attr_name)
  end

  VIROLOGY_ATTRIBUTES.each do |virology_attr|
    context "when the patient has #{virology_attr} only with a Yes and year of 2011" do
      before do
        patient.document.public_send(virology_attr).status = :yes
        patient.document.public_send(virology_attr).confirmed_on_year = 2011
      end
      it "displays only #{virology_attr}, including the year" do
        render partial: partial, locals: { patient: patient }

        expect(rendered).to include(human_virology_attribute_name_for(virology_attr))
        expect(rendered).to include("Yes (2011)")

        # The other ones should not be displayed
        (VIROLOGY_ATTRIBUTES - [virology_attr]).each do |absent_virology_attribute|
          expect(rendered).not_to include(
            human_virology_attribute_name_for(absent_virology_attribute)
          )
        end
      end
    end
  end
end
