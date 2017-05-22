require "rails_helper"

module Renalware
  RSpec.describe Pathology::ObservationRequest, type: :model do
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to validate_presence_of(:requested_at) }
    it { is_expected.to validate_presence_of(:requestor_name) }
    it { is_expected.to belong_to(:patient).touch(true) }
  end
end
