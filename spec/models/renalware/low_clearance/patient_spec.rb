# frozen_string_literal: true

require "rails_helper"

describe Renalware::LowClearance::Patient, type: :model do
  it { is_expected.to have_one(:profile) }
end
