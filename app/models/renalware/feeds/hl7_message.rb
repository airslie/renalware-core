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

        def ordering_provider
          super
        end

        def placer_order_number
          super.split("^").first
        end

        def date_time
          observation_date
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
