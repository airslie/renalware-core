# frozen_string_literal: true

require "rails_helper"

RSpec.describe Renalware::Virology::Patient do
  it { is_expected.to have_one(:profile) }
end
