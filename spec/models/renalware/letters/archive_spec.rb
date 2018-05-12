# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Letters::Archive, type: :model do
    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to belong_to(:letter).touch(true) }
  end
end
