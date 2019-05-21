# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    module TreatmentTimeline
      class GenerateHDTimeline
        pattr_initialize :modality
        delegate :patient, to: :modality

        def call
          create_treatment_from_modality
          create_treatments_within_modality
          deduplicate
        end

        private

        def create_treatment_from_modality
          treatments << Treatment.create!(
            patient: patient,
            clinician: modality.created_by,
            started_on: modality.started_on,
            ended_on: modality.ended_on,
            modality_code: treatment
          )
        end

        # 3 things trigger a new Treatment for an HD patient
        # - change of site
        # - change of hd_type to from hd and (hdf_pre || hdf_post)
        # - change of medications
        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def create_treatments_within_modality
          profiles = hd_profiles_for(patient, from: modality.started_on, to: modality.ended_on)
          last_profile = NullObject.instance
          profiles.each do |profile|
            hd_type = profile.document.dialysis.hd_type
            next if last_profile.document.dialysis.hd_type == hd_type

            treatments << Treatment.create!(
              patient: patient,
              clinician: modality.created_by,
              started_on: modality.started_on,
              ended_on: modality.ended_on,
              modality_code: treatment_for_hd_type(hd_type)
            )
          end
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        # - if modality started on same day as hd profile prescribed then use HD Profile hd_type
        #   if present else hd
        # - if modality started before hd_profile setup and hd_profile is hdf, we'll have
        #   2 treatments: hd then hdf
        # - if hosp unit changes within the modality timeframe, trigger a new treatment
        # - if medications change? new treatment? Check with GS
        def deduplicate
          # p treatments.map(&:id)
        end

        def treatments
          @treatments ||= []
        end

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

          scope = Renalware::HD::Profile
            .with_deactivated
            .order(prescribed_on: :asc, deactivated_at: :desc)

          scope
            .where(conditions.merge(deactivated_at: from..to))
            .or(scope.where(conditions.merge(deactivated_at: nil)))
        end

        def hd_patient
          Renalware::HD.cast_patient(patient)
        end

        def treatment
          ModalityCode.find_by!(description: "Haemodialysis")
        end
      end
    end
  end
end
