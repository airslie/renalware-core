# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe ProviderUnit, type: :model do
      it { is_expected.to belong_to(:hospital_unit) }
      it { is_expected.to belong_to(:hd_provider) }
      it { is_expected.to validate_presence_of(:hospital_unit) }
      it { is_expected.to validate_presence_of(:hd_provider) }
      it { is_expected.to have_db_index(%i(hd_provider_id hospital_unit_id)).unique(true) }
    end
  end
end
