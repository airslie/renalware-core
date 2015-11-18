require "rails_helper"

module Renalware
  module Transplants
    describe RecipientOperation do
      let(:clinician) { create(:user, :clinician) }

      it { is_expected.to validate_presence_of(:performed_on) }
      it { is_expected.to validate_presence_of(:theatre_case_start_time) }
      it { is_expected.to validate_presence_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_presence_of(:kidney_perfused_with_blood_at) }
      it { is_expected.to validate_presence_of(:operation_type) }
      it { is_expected.to validate_presence_of(:transplant_site) }
      it { is_expected.to validate_presence_of(:cold_ischaemic_time) }

      it { is_expected.to validate_timeliness_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_timeliness_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_timeliness_of(:kidney_perfused_with_blood_at) }
      it { is_expected.to validate_timeliness_of(:theatre_case_start_time) }
      it { is_expected.to validate_timeliness_of(:cold_ischaemic_time) }
    end
  end
end
