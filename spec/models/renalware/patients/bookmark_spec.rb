require "rails_helper"

module Renalware
  module Patients
    describe Bookmark do

      describe "validation" do
        let(:patient) { build(:patient) }
        let(:user) { build(:patients_user) }
        subject { Bookmark.new(patient: patient, user: user) }
        it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:patient_id, :deleted_at]) }
      end

      describe "class methods" do
        subject { Bookmark }
        let(:patient) { create(:patient) }
        let(:user) { create(:patients_user) }
        it { expect(subject).to respond_to(:with_deleted) }
      end
    end
  end
end
