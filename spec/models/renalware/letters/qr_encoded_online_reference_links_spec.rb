# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe QREncodedOnlineReferenceLink do
      it { is_expected.to belong_to(:letter) }
      it { is_expected.to belong_to(:online_reference_link).counter_cache(:usage_count) }
    end
  end
end
