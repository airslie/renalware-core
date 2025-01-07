module Renalware
  module Feeds
    module HL7Segments
      # PatientVisit1 segment
      class PV1 < SimpleDelegator
        # This class is a wrapper around PV1.3 Assigned Location, in the same way as the Clinic
        # class below is. This class is used for inpatient messages.
        class AssignedLocation
          def initialize(field)
            @fields = field.split("^")
          end

          def ward                  = fields[0]
          def room                  = fields[1]
          def bed                   = fields[2]
          def facility              = fields[3]
          def location_status       = fields[4]
          def person_location_type  = fields[5]
          def building              = fields[6]
          def floor                 = fields[7]
          def location_description  = fields[8]

          private attr_reader :fields
        end

        # This class is a wrapper around PV1.3 Assigned Location, in the same way as the
        # AssignedLocation class above is. This class is used for outpatient messages.
        class Clinic
          def initialize(field)
            @fields = field.split("^")
          end

          def code          = fields.first
          def name          = fields[1]
          def description   = fields[2]

          private attr_reader :fields
        end

        class Consultant
          def initialize(field)
            @fields = field.split("^")
          end

          def code        = fields.first
          def name        = [title, given_name, family_name].compact_blank.join(" ")
          def family_name = fields[1]
          def given_name  = fields[2]
          def title       = fields[5]
          def type        = fields[12]

          private attr_reader :fields
        end

        def clinic            = Clinic.new(__getobj__.assigned_location)
        def assigned_location = AssignedLocation.new(super)
        def prior_location    = AssignedLocation.new(super)
        def referring_doctor  = Consultant.new(super)
        def attending_doctor  = Consultant.new(super)
        def consulting_doctor = Consultant.new(super)
        def visit_number      = super&.split("^")&.first
      end
    end
  end
end
