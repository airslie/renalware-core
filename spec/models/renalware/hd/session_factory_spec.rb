require "rails_helper"

module Renalware
  module HD
    RSpec.describe SessionFactory, type: :model do
      let(:user) { create(:user, :admin) }
      let(:patient) { create(:patient) }

      subject { SessionFactory.new(patient: patient, user: user) }

      describe "#build" do
        it "applies default to the session" do
          travel_to Time.new(2004, 11, 24, 01, 04, 44)

          session = subject.build

          expect(session.performed_on).to eq(1.hour.ago.to_date)
          expect(session.signed_on_by).to eq(user)
          expect(session.start_time).to eq(Time.new(2004, 11, 24, 01, 00, 00))
        end

        context "with HD profile" do
          let!(:profile) { create(:hd_profile, patient: patient) }

          it "applies defaults from HD profile" do
            session = subject.build

            expect(session.hospital_unit).to eq(profile.hospital_unit)
            expect(session.document.info.hd_type).to eq(profile.document.dialysis.hd_type)
          end
        end

        context "with a current access" do
          let(:accesses_patient) { ActiveType.cast(patient, Accesses::Patient) }
          let!(:profile) { create(:access_profile, :current, patient: accesses_patient) }

          it "applies the access details from the current access" do
            session = subject.build

            expect(session.document.info.access_type).to eq(profile.type.name)
            expect(session.document.info.access_site).to eq(profile.site.name)
            expect(session.document.info.access_side).to eq(profile.side)
          end
        end
      end
    end
  end
end