# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe PatientDocument, type: :model do
    it { is_expected.to respond_to(:history) }
    it { is_expected.to respond_to(:referral) }
    it { is_expected.to respond_to(:psychosocial) }
    it { is_expected.to respond_to(:diabetes) }
    it { is_expected.to respond_to(:hiv) }
    it { is_expected.to respond_to(:hepatitis_b) }
    it { is_expected.to respond_to(:hepatitis_c) }
  end
end
