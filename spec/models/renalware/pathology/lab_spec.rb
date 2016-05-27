require "rails_helper"

describe Renalware::Pathology::Lab do
  it { is_expected.to validate_presence_of(:name) }
end
