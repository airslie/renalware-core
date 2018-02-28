require "rails_helper"

RSpec.describe Renalware::Virology::Profile do
  it { is_expected.to belong_to(:patient).touch(true) }
end
