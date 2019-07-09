# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

# rubocop:disable Rails/Output
module Renalware
  module UKRDC
    module TreatmentTimeline
      module Generators
        # Generates a set of treatments based on a PD modality.
        #
        # There will be an initial treatment triggered by the modality itself, and then
        # a treatment for each significant change in the pd regime during the period of the
        # modality (until it ends)
        #
        class PDTimeline
          pattr_initialize :modality
          delegate :patient, to: :modality

          def call
            create_treatment_from_modality
            create_treatments_within_modality
          end

          private

          def create_treatment_from_modality
            treatments << Treatment.create!(
              patient: patient,
              clinician: modality.created_by,
              started_on: modality.started_on,
              ended_on: modality.ended_on,
              modality_code: treatment_for_pd_type(pd_regime_at_start_of_modality),
              modality_id: modality.id,
              pd_regime: pd_regime_at_start_of_modality
            )
          end

          # Find the modality that was active on the day of the modality change
          # The profile might have been added up to say 14 days later however so if there is none
          # active on the day the modality was created, search up to 14 days ahead until we find
          # one. Return nil if none found.
          def pd_regime_at_start_of_modality
            @pd_regime_at_start_of_modality ||= begin
              pd_regime_id = PD::RegimeForModality.find_by!(modality_id: modality.id)&.pd_regime_id
              return if pd_regime_id.blank?

              PD::Regime.find(pd_regime_id)
            end
          end

          # Things that trigger a new Treatment for an PD patient
          # - change of regime type eg from APD to CAPD
          # - ?
          # Loop through the patient's regimes and trigger a new treatment when these change
          def create_treatments_within_modality
            last_regime = pd_regime_at_start_of_modality

            pd_regimes.each do |regime_|
              regime = PDRegimeDecorator.new(regime_, last_regime: last_regime)
              create_treatment_from(regime) if last_regime.nil? || regime.changed?
              last_regime = regime
            end
          end

          # Note be sure not to include the regime at the start of the modality otherwise we could
          # output this as a duplicate treatment
          def pd_regimes
            regimes = PD::RegimesInDateRangeQuery.new(
              patient: patient,
              from: modality.started_on,
              to: modality.ended_on
            ).call
            regimes - Array(pd_regime_at_start_of_modality)
          end

          # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          def create_treatment_from(regime)
            code = treatment_for_pd_type(regime)
            start_date = regime.present? ? regime.start_date : modality.started_on
            end_date = regime.present? ? regime.end_date : modality.ended_on

            print "[#{code&.txt_code}] "
            treatments << Treatment.create!(
              patient: patient,
              clinician: modality.created_by,
              started_on: start_date,
              ended_on: end_date,
              modality_id: modality.id,
              modality_code: code
            )

            # Update the end date on the previous treatment - ie th eone we just added is
            # taking over as the currently active treatment
            unless treatments.length <= 1
              previous_treatment = treatments[treatments.length - 2]
              previous_treatment.update!(ended_on: start_date)
            end
          end
          # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

          def treatments
            @treatments ||= []
          end

          def treatment_for_pd_type(regime)
            return default_treatment if regime.blank?

            ukrr_name = case regime.pd_type
                        when :apd then "APD"
                        when :capd then "CAPD"
                        end
            UKRDC::ModalityCode.find_by!(description: ukrr_name)
          end

          def pd_patient
            Renalware::PD.cast_patient(patient)
          end

          def default_treatment
            ModalityCode.find_by!(txt_code: 19)
          end
        end
      end
    end
  end
end
# rubocop:enable Rails/Output
