# frozen_string_literal: true

require "rails_helper"

module Renalware::Accesses
  describe Site, type: :model do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
