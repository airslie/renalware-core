require "rails_helper"

module Renalware
  module HD
    describe PatientStatistics, type: :model do
      it { is_expected.to validate_presence_of(:period_starts_at) }
      it { is_expected.to validate_presence_of(:patient) }

      it { is_expected.to have_db_index(:patient_id) }
      it { is_expected.to have_db_index(:period_starts_at) }
    end
  end
end
