# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::TransplantOperationPresenter do
    subject(:presenter) { described_class.new(operation) }

    let(:operation) { build(:transplant_recipient_operation, operation_type: operation_type) }
    let(:operation_type) { :kidney }

    # operation_type in %i(kidney kidney_dual kidney_pancreas pancreas kidney_liver liver)
    describe "ProcedureType" do
      subject { presenter.procedure_type_snomed_code }

      %i(kidney_dual kidney kidney_dual kidney_liver liver).each do |operation_type|
        context "when the operation_type is #{operation_type}" do
          let(:operation_type) { operation_type }

          it { is_expected.to eq("70536003​") }
        end
      end

      context "when the operation_type is kidney_pancreas" do
        let(:operation_type) { :kidney_pancreas }

        it { is_expected.to eq("6471000179103​") }
      end

      context "when the operation_type is pancreas" do
        let(:operation_type) { :pancreas }

        it { is_expected.to eq("62438007​") }
      end
    end
  end
end
