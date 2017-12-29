require "rails_helper"

module Renalware
  describe Admissions::AdmissionSearchForm do
    it "extracts inputs and invokes the query object with them" do
      form = described_class.new(
        hospital_unit_id: "1",
        hospital_ward_id: "2",
        status: "test_scope_selected_from_dropdown",
        term: "123"
      )

      expect(Admissions::AdmissionQuery).to receive(:call).with(
        {
          hospital_unit_id_eq: 1,
          hospital_ward_id_eq: 2,
          test_scope_selected_from_dropdown: true,
          identity_match: "123"
        }
      )

      form.submit
    end
  end
end
