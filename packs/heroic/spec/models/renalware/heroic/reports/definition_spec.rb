# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Reports::Definition do
    it { is_expected.to respond_to(:name) }
  end
end
