# frozen_string_literal: true

require "rails_helper"

module Renalware::Messaging::Internal
  describe Message, type: :model do
    it { is_expected.to be_a(Renalware::Messaging::Internal::Message) }
  end
end
