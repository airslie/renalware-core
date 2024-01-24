# frozen_string_literal: true

module Renalware
  module Feeds
    module PatientLocatorStrategies
      # As used at MSE for ADT HL7 messages.
      #
      # Logic:
      #
      #   if NHS number is in message
      #     find patient by nhs_number and any on local patient id
      #     if no local_patient_id match then use NHS number and DOB
      #   else
      #     find patient where dob and local_patient_id(x)
      #
      class Dynamic
        include Callable

        pattr_initialize [:patient_identification!, relation: Renalware::Patient.where("1 =? ", 1)]
        delegate :identifiers, to: :patient_identification
        delegate :nhs_number, to: :patient_identification

        # Build an AR query to try and find the target patient
        def call
          if nhs_number?
            match_on_nhs_number
            if local_patient_id_identifiers?
              match_on_any_local_patient_id
              # Note that if a hosp number is in the PID, it does not automatically follow that
              # we can match using it. For example if a patient exists in Rw with only an NHS number
              # and then we subsequently get a message with an NHS number and a hosp num, tring to
              # match using 'where nhs_number = '123' and (local_patient_id = 'new number') will not
              # find them, so in this instance we fallback to matching by NHS + DOB instead.
              # Not that if the message wants to change the DOB in Rw, ie it contains a corrected
              # DOB different to that stored in Rw, then there will be no match. We don't have a
              # clever solution to this yet other than to inform an admin of a close match.
              if relation.empty?
                reset_relation
                match_on_nhs_number
                match_on_dob
              end
            else
              match_on_dob
            end
          else
            match_on_dob
            match_on_any_local_patient_id
          end

          if relation.length > 1 # avoid a count query
            # Will go back in the queue
            raise ArgumentError, "More than one patient matches! #{relation.to_sql}"
          else
            relation.first # may be null if no match
          end
        end

        def nhs_number? = nhs_number.present?
        def local_patient_id_identifiers = identifiers.except(:nhs_number)
        def local_patient_id_identifiers? = local_patient_id_identifiers.any?

        def reset_relation
          self.relation = Renalware::Patient.where("1 =? ", 1)
        end

        def match_on_dob
          raise(ArgumentError, "cannot match on DOB is there is none") if born_on.blank?

          self.relation = relation.where(born_on: born_on)
        end

        def match_on_nhs_number
          self.relation = relation.where(nhs_number: nhs_number)
        end

        def match_on_any_local_patient_id
          unless local_patient_id_identifiers?
            raise(ArgumentError, "cannot match on hosp numbers as there are none")
          end

          local_patient_id_identifiers.each do |column, hosp_no|
            self.relation = relation.where(column => hosp_no)
          end
        end

        def born_on
          Date.parse(patient_identification.born_on) if patient_identification.born_on.present?
        end

        private

        attr_accessor :relation
      end
    end
  end
end
