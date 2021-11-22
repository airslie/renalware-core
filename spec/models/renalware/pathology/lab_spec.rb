# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::Lab do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to be_versioned }
end
