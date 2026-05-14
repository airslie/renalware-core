# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class Address < Rendering::Base
            pattr_initialize [:address!, anonymised: false]

            def xml
              address_element
            end

            private

            def address_element
              create_node("Address") do |elem|
                elem[:use] = "H"
                elem << create_node("Street", anonymised ? nil : address.street)
                elem << create_node("Town", anonymised ? nil : address.town)
                elem << create_node("County", anonymised ? nil : address.county)
                elem << create_node("Postcode", postcode)
                elem << country_element if county_code?
              end
            end

            def postcode
              return address.postcode&.strip unless anonymised

              outward_postcode
            end

            def outward_postcode
              postcode = address.postcode&.strip
              return if postcode.blank?
              return postcode.split.first if postcode.include?(" ")

              postcode.length > 3 ? postcode[0...-3] : postcode
            end

            def country_element
              create_node("Country") do |elem|
                elem << create_node(:CodingStandard, "ISO3166-1")
                elem << create_node(:Code, address&.country&.alpha3)
                elem << create_node(:Description, address&.country&.to_s)
              end
            end

            def county_code?
              address&.country&.alpha3.present?
            end
          end
        end
      end
    end
  end
end
