module Renalware
  module UKRDC
    module TreatmentTimeline
      #
      # Re-generates the ukrdc_treatments for a patient from their modalities and other information.
      #
      class GenerateTimeline
        pattr_initialize :patient

        def call
          # RemapModelTableNamesToTheirPreparedEquivalents.new.call do
          create_first_assessment_treatment
          Rails.logger.info "    Generating Treatment rows for modalities #{modality_names}"
          modalities.each do |modality|
            generator = GeneratorFactory.call(modality)
            generator.call
          end
          # end
        end

        private

        def create_first_assessment_treatment
          return if renal_profile&.first_seen_on.blank?

          Treatment.create!(
            patient: patient_record,
            modality_code: first_assessment_modality_code,
            started_on: renal_profile.first_seen_on
          )
        end

        def first_assessment_modality_code
          @first_assessment_modality_code ||= UKRDC::ModalityCode.find_by!(txt_code: 101)
        end

        def renal_profile
          @renal_profile ||= Renal.cast_patient(patient_record).profile
        end

        def patient_record
          @patient_record ||= patient.respond_to?(:__getobj__) ? patient.__getobj__ : patient
        end

        def modalities
          @modalities ||= begin
            patient
              .modalities
              .includes(:description, :created_by)
              .order(started_on: :asc, updated_at: :asc)
          end
        end

        def modality_names
          modalities.map { |mod| mod.description.name }.join("->")
        end
      end
    end
  end
end
