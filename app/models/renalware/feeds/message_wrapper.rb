require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageWrapper < SimpleDelegator
      def initialize(message_string)
        @message_string = message_string
        super(::HL7::Message.new(message_string.lines))
      end

      class ObservationRequest < SimpleDelegator
        def initialize(observation_request_segment, observations_segments)
          @observations_segments = observations_segments
          super(observation_request_segment)
        end

        def observations
          @observations_segments.map { |segment| Observation.new(segment) }
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
        def comment
          observation_value
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

      def to_s
        @message_string
      end
    end
  end
end
