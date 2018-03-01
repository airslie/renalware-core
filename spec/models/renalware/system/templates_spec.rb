# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe System::Template, type: :model do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
