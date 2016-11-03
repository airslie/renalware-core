module Renalware
  module HD
    module Sessions
      class PatientSessionsWithinPeriodQuery

        def self.call(args)
          new.call(**args)
        end

        def call(patient:, starting_on:, ending_on:)
          QueryableSession
            .for_patient(patient)
            .not_ongoing
            .within_period(starting_on, ending_on)
        end

        class QueryableSession < ActiveType::Record[Session]
          include PatientScope

          scope :within_period, ->(starting_on, ending_on) {
             where("performed_on >= ? and performed_on <= ?",
                   starting_on.beginning_of_day,
                   ending_on.end_of_day)
          }

          # We want Closed and DNA sessions but not open ones
          # We can't use session start and end dates to select those STI types because
          # DNA does not have an end time
          scope :not_ongoing, ->{
            where(type: [Session::Closed.sti_name, Session::DNA.sti_name])
          }
        end
      end
    end
  end
end
