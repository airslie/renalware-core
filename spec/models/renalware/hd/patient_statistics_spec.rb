require "rails_helper"

module Renalware
  module HD
    describe PatientStatistics, type: :model do
      it { is_expected.to validate_presence_of(:hospital_unit) }
      it { is_expected.to validate_presence_of(:patient) }

      it { is_expected.to have_db_index(:patient_id) }
      it { is_expected.to have_db_index([:patient_id, :month, :year]).unique(true) }

    end
  end
end
