require "rails_helper"

module Renalware
  module Patients
    describe Alert do
      it { is_expected.to validate_presence_of(:notes) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to respond_to(:deleted_at) }
      it { is_expected.to belong_to(:patient) }

      describe "class methods" do
        it { expect(described_class).to respond_to(:with_deleted) }
      end
    end
  end
end
