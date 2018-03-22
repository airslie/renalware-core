# frozen_string_literal: true

require "rails_helper"

RSpec.describe Renalware::Clinical::Patient, type: :model do
  it { is_expected.to have_many :allergies }

  describe "#allergy_status default value" do
    subject(:allergy_status) { described_class.new.allergy_status }

    it { is_expected.to be_unrecorded }
  end
end
