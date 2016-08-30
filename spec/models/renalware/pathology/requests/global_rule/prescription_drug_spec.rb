require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRule::PrescriptionDrug do
  let(:klass) { Renalware::Pathology::Requests::GlobalRule::PrescriptionDrug }

  describe "#drug_present" do
    include_context "a global_rule_set"

    context "with a valid drug" do
      let!(:drug) { create(:drug) }

      subject(:global_rule) do
        klass.new(
          global_rule_set: global_rule_set,
          param_id: drug.id,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { expect(global_rule).to be_valid }
    end

    context "with an invalid drug" do
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
