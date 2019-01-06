# frozen_string_literal: true

require "rails_helper"

module Renalware::Problems
  describe Note, type: :model do
    it_behaves_like "an Accountable model"
    it { is_expected.to belong_to(:problem).touch(true) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
