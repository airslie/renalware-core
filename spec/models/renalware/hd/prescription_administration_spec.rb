require "rails_helper"

module Renalware
  module HD
    RSpec.describe PrescriptionAdministration, type: :model do
      it { is_expected.to belong_to(:prescription) }
      it { is_expected.to belong_to(:hd_session) }
      it { is_expected.to validate_presence_of(:prescription) }
    end
  end
end
