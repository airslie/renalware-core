require "rails_helper"

module Renalware
  module Patients
    describe Bookmark do
      describe "validation" do
        subject { Bookmark.new(patient: patient, user: user) }

        let(:patient) { build(:patient, by: user) }
        let(:user) { build(:patients_user) }

        it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:patient_id, :deleted_at]) }
      end

      describe "class methods" do
        subject { Bookmark }

        let(:patient) { create(:patient, by: user) }
        let(:user) { create(:patients_user) }

        it { expect(subject).to respond_to(:with_deleted) }
      end
    end
  end
end
