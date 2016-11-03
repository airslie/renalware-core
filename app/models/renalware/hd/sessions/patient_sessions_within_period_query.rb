module Renalware
  module HD
    module Sessions
      class PatientSessionsWithinPeriodQuery

        def self.call(args)
          new.call(**args)
        end

        def call(patient:, starting_on:, ending_on:)
          Session.all
            .extending(Scopes)
            .for_patient(patient)
            .not_ongoing
            .within_period(starting_on, ending_on)
        end

        module Scopes

          def for_patient(patient)
            where(patient: patient)
          end

          def within_period(starting_on, ending_on)
             where("performed_on >= ? and performed_on <= ?",
                   starting_on.beginning_of_day,
                   ending_on.end_of_day)
          end

          def not_ongoing
            where(type: [Session::Closed.sti_name, Session::DNA.sti_name])
          end
        end
      end
    end
  end
end
