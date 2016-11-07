require "rails_helper"

module Renalware
  module HD
    module Sessions
      describe LatestPatientSessionsQuery, type: :model do
        subject(:query) { described_class }
        let(:patient) { create(:hd_patient) }
        let(:user) { create(:user) }
        let(:hospital_unit) { create(:hospital_unit) }
        let(:options) do
          {
            patient: patient,
            created_by: user,
            signed_on_by: user,
            hospital_unit: hospital_unit,
            performed_on: 1.weeks.ago
          }
        end

        it "selects only closed and dna sessions" do
          create(:hd_closed_session, **options) # will be included
          create(:hd_dna_session, **options)    # will be included
          create(:hd_open_session, **options)   # will be excluded

          sessions = query.new(patient: patient).call

          expect(sessions.count).to eq(2)
          types = sessions.map(&:type).uniq.sort
          expect(types).to eq([Session::Closed.sti_name, Session::DNA.sti_name])
        end

        it "does not select sessions older than 4 weeks" do
          expected_session = create(:hd_closed_session, **options.merge(performed_on: 3.weeks.ago))
          create(:hd_closed_session, **options.merge(performed_on: 5.weeks.ago)) # unexpected

          sessions = query.new(patient: patient).call

          expect(sessions.count).to eq(1)
          expect(sessions.first).to eq(expected_session)
        end

        it "selects only the last 12 sessions" do
          13.times do
            create(:hd_closed_session, **options.merge(performed_on: 3.weeks.ago))
          end
          sessions = query.new(patient: patient).call
          expect(sessions.count).to eq(12)
        end
      end
    end
  end
end
