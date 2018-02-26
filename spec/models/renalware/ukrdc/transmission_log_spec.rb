require "rails_helper"

module Renalware
  describe UKRDC::TransmissionLog do
    it { is_expected.to validate_presence_of(:sent_at) }
    it { is_expected.to belong_to(:patient).touch(false) }
  end
end
