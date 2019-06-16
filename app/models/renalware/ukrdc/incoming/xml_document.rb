# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module UKRDC
    module Incoming
      # Encapsulates the structure of the UKRDC XML Document.
      # Assumes one patient per file.
      class XmlDocument
        XPATHS = {
          dob: "string(Patient[1]/BirthTime)",
          family_name: "string(Patient[1]/Names[1]/Name/Family)",
          nhs_number: <<-XPATH.squish
            string(
              Patient[1]/
                PatientNumbers/
                  PatientNumber[Organization[text()='NHS']][NumberType[text()='MRN']][1]/
                    Number
            )
          XPATH
        }.freeze

        attr_reader :root

        def initialize(file)
          xml_document = File.open(file) { |f| Nokogiri::XML(f) }
          @root = xml_document.root
        end

        # Accessing eg XmlDocument.new(file).nhs_number will search the document with looked-up
        # entry in the XPATHS constant, to save us having to write attributes for the things we
        # need.
        def method_missing(method_name, *_args, &_block)
          xpath = XPATHS[method_name]
          return root.xpath(xpath) if xpath

          super
        end

        def respond_to_missing?(method_name, *_args)
          XPATHS.key?(method_name)
        end

        # Turn the surveys XML into a hash becuase it is easier to consume
        def surveys
          root.xpath("Surveys/Survey").each_with_object([]) do |survey_node, arr|
            hash = {}
            hash[:code] = survey_node.xpath("string(SurveyType/Code)")
            hash[:time] = survey_node.xpath("string(SurveyTime)")
            hash[:responses] = question_hash_from(survey_node)
            arr << hash
          end
        end

        def question_hash_from(survey_node)
          question_nodes = survey_node.xpath("Questions/Question")
          question_nodes.each_with_object({}) do |question_node, responses|
            code = question_node.xpath("string(QuestionType/Code)")
            response = question_node.xpath("string(Response)")
            responses[code] = response
          end
        end
      end
    end
  end
end
