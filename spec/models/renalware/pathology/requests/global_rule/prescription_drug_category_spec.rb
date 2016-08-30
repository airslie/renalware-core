require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRule::PrescriptionDrugCategory do
  let(:klass) { Renalware::Pathology::Requests::GlobalRule::PrescriptionDrugCategory }

  describe "#drug_category_present" do
    include_context "a global_rule_set"

    context "with a valid drug_category" do
      let!(:drug_category) { create(:pathology_requests_drug_category) }

      subject(:global_rule) do
        klass.new(
          global_rule_set: global_rule_set,
          param_id: drug_category.id,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { expect(global_rule).to be_valid }
    end

    context "with an invalid drug_category" do
      subject(:global_rule) do
        klass.new(
          global_rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { expect(global_rule).to be_invalid }
    end
  end
end
