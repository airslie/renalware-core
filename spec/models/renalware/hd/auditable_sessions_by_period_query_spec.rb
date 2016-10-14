require "rails_helper"

module Renalware
  module HD::Sessions
      describe AuditableSessionsByPeriodQuery do
        subject(:query) { AuditableSessionsByPeriodQuery }
        let(:patient) { create(:hd_patient) }
        let(:ongoing_hd_session) { create(:ongoing_hd_session) }

        it "does not select Open (ongoing) sessions" do
          pending "Waiting for another PR to merged in that will give us the Session::DNA type"
          sessions = query.call(patient: patient,
                                starting_on: Time.zone.today - 1,
                                ending_on: Time.zone.today)

          types = sessions.map(&:type).uniq.sort
          expect(types).to eq([Session::Closed.sti_name, Session::DNA.sti_name])
        end
      end
  end
end
