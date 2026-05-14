# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class Name < Rendering::Base
            pattr_initialize [:nameable!, anonymised: false]

            def xml
              element
            end

            private

            def element
              Ox::Element.new("Name").tap do |elem|
                elem[:use] = "L"
                anonymised ? append_anonymised_names(elem) : append_names(elem)
              end
            end

            def append_anonymised_names(elem)
              elem << create_node("Family", "CONSENT")
              elem << create_node("Given", "REFUSED")
            end

            def append_names(elem)
              elem << create_node("Prefix", nameable.title)
              elem << create_node("Family", nameable.family_name.strip)
              elem << create_node("Given", nameable.given_name.strip)
              elem << create_node("Suffix", nameable.suffix)
            end
          end
        end
      end
    end
  end
end
