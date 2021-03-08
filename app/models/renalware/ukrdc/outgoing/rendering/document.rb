# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Document < Rendering::Base
          pattr_initialize [:letter!]

          def xml
            document_element
          end

          private

          # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          def document_element
            create_node("Document") do |elem|
              elem << create_node("DocumentTime", letter.datetime.iso8601)
              elem << Clinician.new(user: letter.author).xml
              elem << create_node("DocumentName", letter.title)
              elem << create_node("Status") do |status|
                status << create_node("Code", "ACTIVE")
              end
              elem << EnteredBy.new(user: letter.updated_by).xml
              if letter.hospital_unit_renal_registry_code.present?
                elem << create_node("EnteredAt") do |entered_at|
                  entered_at << create_node("CodingStandard", "LOCAL")
                  entered_at << create_node("Code", letter.hospital_unit_renal_registry_code)
                end
              end
              elem << create_node("FileType", "application/pdf")
              elem << create_node("FileName", letter.pdf_stateless_filename)
              elem << create_node("Stream", encoded_document_content)
            end
          end
          # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

          def encoded_document_content
            Base64.encode64(Renalware::Letters::PdfRenderer.call(letter))
          end
        end
      end
    end
  end
end
