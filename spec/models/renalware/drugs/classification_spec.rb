# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  RSpec.describe Classification, type: :model do
    it { is_expected.to belong_to(:drug).touch(true) }
    it { is_expected.to belong_to(:drug_type) }
  end
end
