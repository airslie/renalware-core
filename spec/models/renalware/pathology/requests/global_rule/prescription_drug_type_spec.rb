# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRule::PrescriptionDrugType do
  let(:klass) { described_class }

  let(:drug_type) { create(:drug_type) }

  describe "#drug_type_present" do
    include_context "a global_rule_set"

    context "with a valid drug_type" do
      subject do
        klass.new(
          rule_set: global_rule_set,
          param_id: drug_type.id,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { is_expected.to be_valid }
    end

    context "with an invalid drug_type" do
      subject do
        klass.new(
          rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: nil,
          param_comparison_value: nil
        )
      end

      it { is_expected.to be_invalid }
    end
  end
end
