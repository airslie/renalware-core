# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinics::VisitLocation do
  it :aggregate_failures do
    is_expected.to be_versioned
    is_expected.to validate_presence_of :name
    is_expected.to have_db_index(:name)
  end

  describe "uniqueness" do
    subject { described_class.new(name: "Telephone") }

    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
