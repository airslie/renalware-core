# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinics::Clinic, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_db_index(:name).unique(true) }
  it { is_expected.to respond_to(:visit_class_name) }

  describe "#uniqueness" do
    subject { described_class.new(name: "X", user_id: user.id) }

    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
