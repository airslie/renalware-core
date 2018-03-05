# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  RSpec.describe FileType do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:prompt) }
    it { is_expected.to have_many(:files) }
  end
end
