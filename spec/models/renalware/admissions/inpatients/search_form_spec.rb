require "rails_helper"

module Renalware
  describe Admissions::Inpatients::SearchForm do
    it "works" do
      form = described_class.new(
        hospital_unit_id: "1",
        hospital_ward_id: "2",
        status: "test_scope_selected_from_dropdown"
      )

      expect(Admissions::Inpatients::Query).to receive(:call).with(
        {
          hospital_unit_id_eq: 1,
          hospital_ward_id_eq: 2,
          test_scope_selected_from_dropdown: true
        }
      )

      form.submit
    end
  end
end
