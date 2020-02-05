# frozen_string_literal: true

require "rails_helper"

describe Renalware::Events::BiopsiesComponent, type: :component do
  subject { described_class.new(patient: patient) }

  let(:patient) { build_stubbed(:patient) }

  # TODO: component tests
end
