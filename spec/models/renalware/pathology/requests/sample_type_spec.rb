# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::Requests::SampleType do
  it :aggregate_failures do
    is_expected.to validate_presence_of(:name)
    is_expected.to validate_presence_of(:code)
  end
end
