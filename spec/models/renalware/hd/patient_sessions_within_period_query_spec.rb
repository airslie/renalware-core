require "rails_helper"

module Renalware
  module HD
    module Sessions
      describe PatientSessionsWithinPeriodQuery do
        subject(:query) { described_class }
        let(:patient) { create(:hd_patient) }
        let(:user) { create(:user) }
        let(:hospital_unit) { create(:hospital_unit) }

        before do
          options = {
            patient: patient,
            created_by: user,
            signed_on_by: user,
            hospital_unit: hospital_unit
          }
          create(:hd_open_session, **options)
          create(:hd_closed_session, **options)
          create(:hd_dna_session, **options)
        end

        it "does not select Open (ongoing) sessions" do

          sessions = query.call(patient: patient,
                                starting_on: 4.weeks.ago,
                                ending_on: Time.zone.today)

          types = sessions.map(&:type).uniq.sort
          expect(types).to eq([Session::Closed.sti_name, Session::DNA.sti_name])
        end
      end
    end
  end
end
