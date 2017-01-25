require "rails_helper"

module Renalware
  module Clinics
    RSpec.describe RememberedClinicVisitPreferences, type: :model do

      describe "#persist" do
        it "saves certain model attributes to the session" do
          visit = double("ClinicVisit", date: Time.zone.now)
          session = {}

          RememberedClinicVisitPreferences.new(session).persist(visit)

          RememberedClinicVisitPreferences::ATTRIBUTES_TO_REMEMBER.each do |attr|
            expect(session[:clinic_visit_preferences]).to have_key(attr)
          end
        end
      end

      describe "#apply_to" do
        it "copies any previously remembered session data to the visit" do
          date = Time.zone.now
          session = { clinic_visit_preferences: { date: date } }
          visit = OpenStruct.new(date: nil)

          RememberedClinicVisitPreferences.new(session).apply_to(visit)

          expect(visit.date).to eq(date)
        end
      end
    end
  end
end
