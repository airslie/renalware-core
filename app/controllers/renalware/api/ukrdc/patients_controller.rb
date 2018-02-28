module Renalware
  module API
    module UKRDC
      class PatientsController < BaseController
        respond_to :xml

        def show
          respond_to do |format|
            format.xml do
              render locals: {
                patient: patient_presenter
              }
            end
          end
        end

        private

        def patient_presenter
          patient = Renalware::Patient.find_by!(secure_id: params[:id])
          authorize patient
          Renalware::UKRDC::PatientPresenter.new(patient, changes_since: params[:changes_since])
        end
      end
    end
  end
end

# An alternative xml rendering implementation - moved to a template based approach
# for now as its provides clarity
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
