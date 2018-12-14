# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class XmlRenderer
      DEFAULT_TEMPLATE = "/renalware/api/ukrdc/patients/show"
      attr_reader :template, :xsd_path, :locals

      def initialize(template: nil, xsd_path: nil, locals: {})
        @template = template || DEFAULT_TEMPLATE
        @xsd_path = xsd_path || default_xsd_path
        @locals = locals
      end

      def call
        if validation_errors.any?
          raise(ArgumentError, validation_errors.join(", "))
        end

        xml
      end

      def xml
        @xml ||= begin
          API::UKRDC::PatientsController.new.render_to_string(
            template: template,
            format: :xml,
            locals: locals,
            encoding: "UTF-8"
          )
        end
      end

      private

      def default_xsd_path
        File.join(Renalware::Engine.root, "vendor/xsd/ukrdc/Schema/UKRDC.xsd")
      end

      # Returns an array of SchemaValidation errors
      def validation_errors
        document = Nokogiri::XML(xml)
        xsddoc = Nokogiri::XML(File.read(xsd_path), xsd_path)
        schema = Nokogiri::XML::Schema.from_document(xsddoc)
        schema.validate(document)
      end
    end
  end
end

#
# An alternative xml rendering implementation - we moved to a template based approach
# for now as its provides more clarity
#

# class Base
#   include ActiveModel::Serializers::Xml
#   include Virtus::Model
# end

# class PatientNumber < Base
#   attribute :number, String
#   attribute :organisation, String

#   def self.build_nhs_number(number)
#     new(number: number, organisation: "NHS")
#   end
# end

# class Name < Base
#   attribute :prefix, String
#   attribute :family, String
#   attribute :given, String
#   attribute :suffix, String
#   attribute :use, String
# end

# class Patient < Base
#   attribute :gender, String # 0=Not Known 1=Male 2=Female 9=Not Specified.
#   attribute :birth_time, DateTime
#   attribute :death_time, DateTime
#   attribute :patient_numbers, Array(PatientNumber)
#   attribute :name, Name
#   attribute :country_of_birth, String # ISO 3166-1 3-char alphabetic code
# end

# rdc_patient = UKRDC::Patient.new(
#   gender: patient.sex&.code,
#   birth_time: patient.born_on,
#   death_time: patient.died_on,
#   country_of_birth: "???"
# )

# rdc_patient.name = Name.new(
#   prefix: patient.title,
#   family: patient.family_name,
#   given: patient.given_name,
#   suffix: patient.suffix
# )

# rdc_patient.patient_numbers << UKRDC::PatientNumber.build_nhs_number(patient.nhs_number)
# Renalware.config.patient_hospital_identifiers.each do |_key, field|
#   number = patient.public_send(field)
#   unless number.blank?
#     patient_number = UKRDC::PatientNumber.new(number: number, organisation: "LOCALHOSP")
#     rdc_patient.patient_numbers << patient_number
#   end
# end

# # Render XML
# respond_with rdc_patient, camelize: true
#
