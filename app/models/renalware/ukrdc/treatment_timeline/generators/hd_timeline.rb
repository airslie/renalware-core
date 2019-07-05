# frozen_string_literal: true

require_dependency "renalware/ukrdc"

# rubocop:disable Rails/Output
module Renalware
  module UKRDC
    module TreatmentTimeline
      module Generators
        class HDTimeline
          pattr_initialize :modality
          delegate :patient, to: :modality

          def call
            create_treatment_from_modality
            create_treatments_within_modality
            deduplicate
          end

          private

          def create_treatment_from_modality
            print "[#{treatment.txt_code}] "
            treatments << Treatment.create!(
              patient: patient,
              clinician: modality.created_by,
              started_on: modality.started_on,
              ended_on: modality.ended_on,
              modality_code: treatment,
              hd_profile: hd_profile_at_start_of_modality
            )
          end

          # Find the modality that was active on the day of the modality change
          # The profile might have been added up to say 14 days later however so if there is none
          # active on the day the modality was created, search up to one week ahead until we find
          # one. Return nil if none found.
          # Its complicated a bit by the fact that although there is a prescribed_on in the
          # hd_profile, it is sometimes missing so we need to default to created_at in that
          # instance.
          def hd_profile_at_start_of_modality
            @hd_profile_at_start_of_modality ||= begin
              hd_profile_id = HD::ProfileForModality.find_by!(
                modality_id: modality.id
              ).hd_profile_id
              return if hd_profile_id.blank?

              HD::Profile.with_deactivated.find(hd_profile_id)
            end
          end

          class ProfileDecorator < DumbDelegator
            def initialize(profile, last_profile:)
              @last_profile = last_profile
              super(profile)
            end

            def hd_type
              document.dialysis.hd_type
            end

            def changed?
              return true if last_profile.blank?

              hd_type_changed? || hospital_unit_changed?
            end

            def unchanged?
              !changed?
            end

            def hd_type_changed?
              last_profile.document.dialysis.hd_type != hd_type
            end

            def hospital_unit_changed?
              last_profile.hospital_unit_id != hospital_unit_id
            end

            private

            attr_reader :last_profile
          end

          # 3 things trigger a new Treatment for an HD patient
          # - change of site
          # - change of hd_type to from hd and (hdf_pre || hdf_post)
          # - change of hd prescription
          # Loop through the hd_profiles and trigger an new treatment when these change
          # There is a problem here as we are creating duplicate treatments
          # I think we need to first find the hd profile that is associated with the hd modality
          # and that becomes the 'last_profile' here
          def create_treatments_within_modality
            last_profile = hd_profile_at_start_of_modality

            hd_profiles.each do |profile_|
              profile = ProfileDecorator.new(profile_, last_profile: last_profile)
              create_treatment_from(profile) if last_profile.nil? || profile.changed?
              last_profile = profile
            end
          end

          def hd_profiles
            hd_profiles_for(
              patient,
              from: modality.started_on,
              to: modality.ended_on
            ) - Array(hd_profile_at_start_of_modality)
          end

          # - if modality started on same day as hd profile prescribed then use HD Profile hd_type
          #   if present else hd
          # - if modality started before hd_profile setup and hd_profile is hdf, we'll have
          #   2 treatments: hd then hdf
          # - if hosp unit changes within the modality timeframe, trigger a new treatment
          # - if medications change? new treatment? Check with GS
          def deduplicate
            # p treatments.map(&:id)
          end

          # rubocop:disable Metrics/AbcSize
          def create_treatment_from(profile)
            code = treatment_for_hd_type(profile.hd_type)
            print "[#{code.txt_code}] "
            treatments << Treatment.create!(
              patient: patient,
              clinician: modality.created_by,
              started_on: modality.started_on,
              ended_on: modality.ended_on,
              modality_code: treatment_for_hd_type(profile.hd_type)
            )
          end
          # rubocop:enable Metrics/AbcSize

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
end
# rubocop:enable Rails/Output
