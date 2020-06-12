# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    # Responsible for representing an HL7 message. Fields can be queried via
    # chained method calls. For example, accessing the patient identifier field
    # in the PID segment can be accessed by calling:
    #
    #   HL7Message.new(raw_message).patient_identification.internal_id
    #
    class HL7Message < SimpleDelegator
      ACTIONS = {
        "ADT^A28" => :add_person_information,
        "ADT^A31" => :update_person_information,
        "ADT^A08" => :update_admission,
        "ADT^A01" => :admit_patient,
        "ADT^A02" => :transfer_patient,
        "ADT^A03" => :discharge_patient,
        "ADT^A11" => :cancel_admission,
        "MFN^M02" => :add_consultant, # no
        "ADT^A34" => :merge_patient, # no
        "ADT^A13" => :cancel_discharge,
        "ORU^R01" => :add_pathology_observations
      }.freeze

      class ObservationRequest < SimpleDelegator
        alias_attribute :date_time, :observation_date

        def initialize(observation_request_segment)
          super(observation_request_segment)
        end

        def identifier
          universal_service_id.split("^").first
        end

        def name
          universal_service_id.split("^")[1]
        end

        # Select only OBX children. OBR can have other types of child
        # segments but we want to ignore those.
        def observations
          @observations ||= begin
            children
              .select { |segment| segment.is_a? HL7::Message::Segment::OBX }
              .map { |obx_segment| Observation.new(obx_segment) }
          end
        end

        def ordering_provider_name
          ordering_provider.last
        end

        def placer_order_number
          super.split("^").first
        end

        private

        def ordering_provider
          super.split("^")
        end
      end

      class Observation < SimpleDelegator
        attr_reader :cancelled

        alias_attribute :date_time, :observation_date
        alias_attribute :value, :observation_value

        def identifier
          observation_id.split("^").first
        end

        def name
          observation_id.split("^")[1]
        end

        # TODO: Implement comment extraction
        def comment
          @comment || ""
        end

        # Some messages may come through with result text like
        #   ##TEST CANCELLED## Insufficient specimen received
        # in which case replace with something more concise.
        # We could save the actual message somewhere
        def observation_value
          if super.upcase.at("CANCELLED")
            @comment = super
            @cancelled = true
            ""
          else
            super
          end
        end

        # Because some units of measurement, such as 10^12/L for WBC, contain a caret, the caret
        # will initially have been encoded by Mirth as \S\ (a Mirth escape sequence for ^
        # or whatever the mirth component separator character is configured to be)
        # However in the 10^12/L example above, when encoded by Mirth, becomes `10\S\12/L` but
        # the `\12` within the message is interpreted as a `\n` (form feed) by
        # delayed_job when it is read into the yaml format string in the HL7 messages.
        # While it might be possible to write out yaml into delayed_job using a format
        # that will not un-escape on reading, the approach here is that the we have preprocessed
        # the message using a trigger (at the point it is inserted into delayed_jobs) by
        # replacing any instance of \S\ with \\S\\ in the message.
        # Thus the raw data for units in the database will look like `10\\S\\12/L`.
        # When ever this string is loaded by Ruby it will un-escaped and become "\S\"
        # No `\12` is not found and un-escaped to \n"
        # Note in the gsub here we double escape the \'s
        def units
          super&.gsub("\\S\\", "^")
        end
      end

      # There is a problem here is there are < 1 OBR
      # i.e. self[:OBR] could be an array
      def observation_requests
        Array(self[:OBR]).map { |obr| ObservationRequest.new(obr) }
      end

      class PatientIdentification < SimpleDelegator
        alias_attribute :external_id, :patient_id
        alias_attribute :dob, :patient_dob
        alias_attribute :born_on, :patient_dob
        alias_attribute :died_at, :death_date

        def internal_id
          return unless defined?(patient_id_list)

          patient_id_list.split("^").first
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

      def patient_identification
        PatientIdentification.new(self[:PID])
      end

      def type
        self[:MSH].message_type
      end

      def header_id
        self[:MSH].message_control_id
      end

      # Adding this so it is part of the interface and we can mock an HL7Message in tests
      def to_hl7
        super
      end

      def message_type
        type.split("^").first
      end

      def event_type
        parts = type.split("^")
        parts.length == 2 && parts.last
      end

      %i(ORU ADT).each do |msg_type|
        define_method(:"#{msg_type.to_s.downcase}?") do
          msg_type.to_s == message_type
        end
      end

      def action
        ACTIONS.fetch(type, :no_matching_command)
      end

      def practice_code
        self[:PD1].e3.split("^")[2] if self[:PD1]
      end

      def gp_code
        self[:PD1].e4.split("^")[0] if self[:PD1]
      end
    end
  end
end
