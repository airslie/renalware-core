# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class PatientIdentification < SimpleDelegator
      alias_attribute :external_id, :patient_id
      alias_attribute :dob, :patient_dob
      alias_attribute :born_on, :patient_dob
      alias_attribute :died_at, :death_date

      def internal_id
        return unless defined?(patient_id_list)

        patient_id_list.split("^").first
      end

      # Given the following PID segment
      #   PID||123456789^^^NHS^ignoreme|D7006359^^^hosp1~X1234^^^hosp2|
      # this will return a hash of assigning_authority => hospital number
      # useful in the situation where we receive HL7 messages from > 1 PAS; elsewhere
      # we will map the assigning authotity to the correct patient_identitifer
      # e.g. lookup assigning_auth eg "RAJ01" in a map to discover whether we should copy this
      # patient number into local_patient_id, local_patient_2 etc
      # {
      #   "hosp1" => "D7006359",
      #   "hosp2" => "X1234"
      # }
      def hospital_identifiers
        return [] if patient_id_list.blank?

        patient_id_list
          .split("~")
          .each_with_object({}) do |field, hash|
            parts = field.split("^")
            hospno = parts.first
            assigning_authority = parts[3]
            hash[assigning_authority] = hospno
          end
      end

      def nhs_number
        return unless defined?(patient_id)

        patient_id.split("^").first
      end

      def name
        Name.new(patient_name)
      end

      def family_name
        patient_name[0]
      end

      def given_name
        patient_name[1]
      end

      def suffix
        patient_name[3]
      end

      def title
        patient_name[4]
      end

      def address
        super.split("^")
      end

      # We don't use the HL7::Message#sex_admin method (from the ruby hl7 gem) because it
      # raises an error during reading if the sex value in the PID is not in (F|M|O|U|A|N|C).
      # I think that behaviour is a not quite right as a hospital might not use those values in
      # their HL7 PID implementation, especially in the UK. KCH does not for instance.
      # So instead we read the PID array directly, and map whatever is in there to its Renalware
      # equivalent, then overwrite the existing #admin_sex method so the HL7::Message version
      # cannot be called. If we can't map it we just return whatever is in there and its up to
      # calling code to handle any coercion issues. The hl7_pid_sex_map hash can be configured
      # by the host app to support whatever sex values it uses intenrally.
      # I think some work needs to be done on Renalware sex and gender (which are slightly
      # conflated in Renalware). For example:
      # - the LOINC names for administrative sex: Male Female Unknown (https://loinc.org/72143-1/)
      # - the LOINC names for sex at birth: Male Female Unknown (https://loinc.org/LL3324-2/)
      # - HL7's definitions: F Female, M Male, O Other, U Unknown, A Ambiguous, N Not applicable
      # - gender: 7 options https://loinc.org/76691-5/
      def sex
        pid_sex = self[8]&.upcase
        Renalware.config.hl7_pid_sex_map.fetch(pid_sex, pid_sex)
      end
      alias admin_sex sex

      private

      def patient_name
        super.split("^")
      end
    end
  end
end
