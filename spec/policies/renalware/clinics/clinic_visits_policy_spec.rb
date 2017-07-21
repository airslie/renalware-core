require "rails_helper"

module Renalware
  module Clinics
    describe ClinicVisitPolicy, type: :policy do
      subject { described_class }

      let(:user) { User.new }
      let(:clinic_visit) { ClinicVisit.new }

      permissions :destroy? do
        context "for an unsaved clinic visit" do
          it "is not permitted" do
            expect(subject).not_to permit(user, clinic_visit)
          end
        end

        context "for a saved clinic visit" do
          before do
            allow(clinic_visit).to receive(:persisted?).and_return(true)
            Renalware.configure{ |config| config.new_clinic_visit_deletion_window = 24.hours }
          end

          it "is not permitted if creation date not is within the deletion window" do
            allow(clinic_visit).to receive(:created_at).and_return(Time.zone.now - 25.hours)
            expect(subject).not_to permit(user, clinic_visit)
          end

          it "is permitted if creation date is within the deletion window" do
            allow(clinic_visit).to receive(:created_at).and_return(Time.zone.now - 23.hours)
            expect(subject).to permit(user, clinic_visit)
          end
        end
      end
    end
  end
end
