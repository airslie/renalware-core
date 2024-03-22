# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR
    module Support
      module Helpers
        extend ActiveSupport::Concern

        def snomed_coding(code, display)
          {
            coding: {
              system: "http://snomed.info/sct",
              code: code,
              display: display
            }
          }
        end

        def system_identifier(uuid)
          {
            system: "https://tools.ietf.org/html/rfc4122",
            value: uuid
          }
        end

        def html_fragment_from(letter, html_id:)
          fragment = Nokogiri.XML(letter.archive.content)
            .xpath("//*[@id='#{html_id}']")
            .first
            &.to_s
          raise(ArgumentError, html_id) if fragment.blank?

          fragment
        end
      end
    end
  end
end
