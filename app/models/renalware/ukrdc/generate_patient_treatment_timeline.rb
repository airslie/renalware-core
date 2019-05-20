# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module UKRDC
    class GeneratePatientTreatmentTimeline
      pattr_initialize :patient

      def call
        modalities.each do |modality|
          create_treatment_from_modality(modality)
          create_treatments_within_modality(modality)
        end
      end

      private

      def modalities
        patient.modalities.order(started_on: :asc, updated_at: :asc)
      end

      def create_treatment_from_modality(modality)
        Treatment.create!(
          patient: patient,
          clinician: modality.created_by,
          started_on: modality.started_on,
          ended_on: modality.ended_on,
          modality_code: treatment_for(modality)
        )
      end

      def create_treatments_within_modality(modality)
        case modality.description
        when Renalware::HD::ModalityDescription then
          create_sub_hd_treatments_within(modality)
        else raise "unrecognised modality class #{modality.description.class}"
        end
      end

      # 3 things trigger a new Treatment for an HD patient
      # - change of site
      # - change of hd_type to from hd and (hdf_pre || hdf_post)
      # - change of medications
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def create_sub_hd_treatments_within(modality)
        profiles = hd_profiles_for(patient, from: modality.started_on, to: modality.ended_on)
        last_profile = NullObject.instance
        profiles.each do |profile|
          hd_type = profile.document.dialysis.hd_type
          next if last_profile.document.dialysis.hd_type == hd_type

          Treatment.create!(
            patient: patient,
            clinician: modality.created_by,
            started_on: modality.started_on,
            ended_on: modality.ended_on,
            modality_code: treatment_for_hd_type(hd_type)
          )
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def treatment_for_hd_type(hd_type)
        ukrr_name = case hd_type.to_s.downcase
                    when "hd" then "Haemodialysis"
                    when "hdf_pre", "hdf_post" then "Haemodiafiltration"
                    end
        UKRDC::ModalityCode.find_by!(description: ukrr_name)
      end

      def hd_profiles_for(patient, from:, to: Time.zone.now)
        conditions = {
          patient_id: patient.id,
          prescribed_on: from..DateTime::Infinity.new
        }
        scope = HD::Profile.with_deactivated.order(prescribed_on: :asc, deactivated_at: :desc)
        scope
          .where(conditions.merge(deactivated_at: from..to))
          .or(scope.where(conditions.merge(deactivated_at: nil)))
      end

      def hd_patient
        Renalware::HD.cast_patient(patient)
      end

      def treatment_for(modality)
        modality_name = modality.description.name
        case modality_name
        when "HD" then ModalityCode.find_by!(description: "Haemodialysis")
        else raise "dont yet know what to do with #{modality_name}"
        end
      end
    end
  end
end
