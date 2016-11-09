require "rails_helper"

module Renalware
  module HD
    module Sessions
      describe AuditablePatientSessionsInPeriodQuery do
        subject(:query) { described_class.new(patient: patient, period: period) }
        let(:patient) { create(:hd_patient) }
        let(:another_patient) { create(:hd_patient) }
        let(:period) { MonthPeriod.new(month: month, year: year) }
        let(:month) { 12 }
        let(:year) { 2016 }

        it "selects closed and dna sessions within the requested month" do
          # This Nov one is too early
          november_session = travel_to Time.parse("2016-11-30 23:59:00") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.now)
          end

          # These Dec ones are OK...
          travel_to Time.parse("2016-12-01 00:00:00") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.now)
            create(:hd_dna_session, patient: patient, performed_on: Time.now)
            # .. except this one as its not signed off yet
            create(:hd_open_session, patient: patient, performed_on: Time.now)
            # .. and this one as it belongs to another patient
            create(:hd_open_session, patient: another_patient, performed_on: Time.now)
          end

          # ..so are these Dec ones
          travel_to Time.parse("2016-12-31 23:59:00") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.now)
            create(:hd_dna_session, patient: patient, performed_on: Time.now)
          end

          # ..but this Jan one is too late
          january_session = travel_to Time.parse("2017-01-01 00:00:01") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.now)
          end

          # query#call yields for each hd patient, passing their sessions also
          sessions = query.call

          expect(sessions.count).to eq(4)
          expect(sessions).to_not include(november_session)
          expect(sessions).to_not include(january_session)
        end
      end
    end
  end
end
