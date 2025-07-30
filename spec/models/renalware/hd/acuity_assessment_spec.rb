module Renalware
  module HD
    describe AcuityAssessment do
      it :aggregate_failures do
        is_expected.to belong_to(:patient)
        is_expected.to validate_presence_of(:patient_id)
        is_expected.to validate_presence_of(:ratio)
      end
    end
  end
end
