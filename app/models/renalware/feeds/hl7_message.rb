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
      def initialize(message_string)
        @message_string = message_string
        super(::HL7::Message.new(message_string.lines))
      end

      class ObservationRequest < SimpleDelegator
        alias_attribute :date_time, :observation_date

        def initialize(observation_request_segment)
          super(observation_request_segment)
        end

        def identifier
          universal_service_id.split("^").first
        end

        # Select only OBX children. OBR can have other types of child
        # segments but we want to ignore those.
        def observations
          @observations ||= begin
            children
              .select{ |segment| segment.is_a? HL7::Message::Segment::OBX }
              .map{ |obx_segment| Observation.new(obx_segment) }
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
        Array(self[:OBR]).map{ |obr| ObservationRequest.new(obr) }
      end

      class PatientIdentification < SimpleDelegator
        alias_attribute :external_id, :patient_id
        alias_attribute :sex, :admin_sex
        alias_attribute :dob, :patient_dob

        def internal_id
          patient_id_list.split("^").first
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
        @message_string.tr("\r", "\n")
      end
    end
  end
end
