# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::ModalityCode do
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:qbl_code) }
    it { is_expected.to respond_to(:txt_code) }
  end
end
