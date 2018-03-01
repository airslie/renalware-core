# frozen_string_literal: true

require "rails_helper"

module Renalware::Messaging::Internal
  describe Author, type: :model do
    it { is_expected.to have_many(:messages) }
  end
end
