require "rails_helper"

module Renalware
  module Transplants
    describe RecipientOperation do
      let(:clinician) { create(:user, :clinician) }

      it { should belong_to :patient }
      it { should validate_presence_of :performed_on }
      it { should validate_presence_of :theatre_case_start_time }
      it { should validate_presence_of :donor_kidney_removed_from_ice_at }
      it { should validate_presence_of :kidney_perfused_with_blood_at }
      it { should validate_presence_of :operation_type }
      it { should validate_presence_of :transplant_site }
      it { should validate_presence_of :cold_ischaemic_time }
    end
  end
end
