# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinics::Clinic, type: :model do
  it_behaves_like "an Accountable model"
  it_behaves_like "a Paranoid model"

  it { is_expected.to validate_presence_of :name }

  describe "#uniqueness" do
    subject { described_class.new(name: "A", user_id: user.id) }

    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of :code }
  end
end
