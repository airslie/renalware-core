# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe PatientStatistics, type: :model do
      it { is_expected.to validate_presence_of(:hospital_unit) }
      it { is_expected.to validate_presence_of(:patient) }

      it { is_expected.to have_db_index(:patient_id) }
      it { is_expected.to have_db_index([:patient_id, :month, :year]).unique(true) }

      describe "month and year presence validation" do
        context "when rolling is nil" do
          subject { described_class.new(rolling: nil) }

          it { is_expected.to validate_presence_of(:year) }
          it { is_expected.to validate_presence_of(:month) }
        end

        context "when rolling is true" do
          subject { described_class.new(rolling: true) }

          it { is_expected.not_to validate_presence_of(:year) }
          it { is_expected.not_to validate_presence_of(:month) }
        end
      end
    end
  end
end
