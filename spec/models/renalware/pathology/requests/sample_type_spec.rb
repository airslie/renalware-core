# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::Requests::SampleType do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }
end
