# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::Treatment do
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to validate_presence_of(:modality_code) }
  end
end
