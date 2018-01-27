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
      def initialize(message_string)
        @message_string = message_string
        super(::HL7::Message.new(message_string.lines))
      end

      class ObservationRequest < SimpleDelegator
        def initialize(observation_request_segment, observations_segments)
          @observations_segments = observations_segments
          super(observation_request_segment)
        end

        def identifier
          universal_service_id.split("^").first
        end

        def observations
          Array(@observations_segments).map { |segment| Observation.new(segment) }
        end

        def ordering_provider_name
          ordering_provider.last
        end

        def placer_order_number
          super.split("^").first
        end

        def date_time
          observation_date
        end

        private

        def ordering_provider
          super.split("^")
        end
      end

      class Observation < SimpleDelegator
        def identifier
          observation_id.split("^").first
        end

        # TODO: Implement comment extraction
        def comment
          ""
        end

        def date_time
          observation_date
        end

        def value
          observation_value
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

      def observation_request
        ObservationRequest.new(self[:OBR], self[:OBX])
      end

      class PatientIdentification < SimpleDelegator
        def internal_id
          patient_id_list.split("^").first
        end

        def external_id
          patient_id
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

        def sex
          admin_sex
        end

        def dob
          patient_dob
        end

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

      def to_s
        @message_string
      end
    end
  end
end
