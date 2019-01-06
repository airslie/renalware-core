# frozen_string_literal: true

require "rails_helper"

module Renalware::Hospitals
  describe Centre, type: :model do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
