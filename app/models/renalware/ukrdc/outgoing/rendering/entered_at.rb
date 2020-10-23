# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class EnteredAt < Rendering::Base
          pattr_initialize [:hospital_unit!]

          def xml
            element
          end

          private

          def element
            Ox::Element.new("EnteredAt").tap do |elem|
              elem << create_node("CodingStandard", "RR1+")
              elem << create_node("Code", hospital_unit&.renal_registry_code)
              elem << create_node("Description", hospital_unit&.name)
            end
          end
        end
      end
    end
  end
end
