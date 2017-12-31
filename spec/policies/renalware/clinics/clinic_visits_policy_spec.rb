require "rails_helper"

module Renalware
  module Clinics
    describe ClinicVisitPolicy, type: :policy do
      subject(:policy) { described_class }

      let(:user) { User.new }
      let(:clinic_visit) { ClinicVisit.new }

      permissions :destroy? do
        context "with an unsaved clinic visit" do
          it "is not permitted" do
            expect(policy).not_to permit(user, clinic_visit)
          end
        end

        context "with a saved clinic visit" do
          before do
            allow(clinic_visit).to receive(:persisted?).and_return(true)
            Renalware.configure{ |config| config.new_clinic_visit_deletion_window = 24.hours }
          end

          it "is not permitted if creation date not is within the deletion window" do
            allow(clinic_visit).to receive(:created_at).and_return(Time.zone.now - 25.hours)
            expect(policy).not_to permit(user, clinic_visit)
          end

          it "is permitted if creation date is within the deletion window" do
            allow(clinic_visit).to receive(:created_at).and_return(Time.zone.now - 23.hours)
            expect(policy).to permit(user, clinic_visit)
          end
        end
      end
    end
  end
end
