# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    module TreatmentTimeline
      module PD
        # Generates a set of treatments based on a PD modality.
        #
        # There will be an initial treatment triggered by the modality itself, and then
        # a treatment for each significant change in the pd regime during the period of the
        # modality (until it ends)
        #
        class Generator
          pattr_initialize :modality
          delegate :patient, to: :modality

          def call
            create_treatment_from_modality
            create_treatments_within_modality
          end

          private

          def create_treatment_from_modality
            create_treatment(
              pd_regime_at_start_of_modality,
              modality.started_on,
              modality.ended_on
            )
          end

          # Find the modality that was active on the day of the modality change
          # The profile might have been added up to say 14 days later however so if there is none
          # active on the day the modality was created, search up to 14 days ahead until we find
          # one. Return nil if none found.
          def pd_regime_at_start_of_modality
            @pd_regime_at_start_of_modality ||= begin
              pd_regime_id = Renalware::PD::RegimeForModality.find_by!(
                modality_id: modality.id
              )&.pd_regime_id
              return if pd_regime_id.blank?

              Renalware::PD::Regime.find(pd_regime_id)
            end
          end

          # Things that trigger a new Treatment for an PD patient
          # - change of regime type eg from APD to CAPD
          # - ?
          # Loop through the patient's regimes and trigger a new treatment when these change
          def create_treatments_within_modality
            last_regime = pd_regime_at_start_of_modality

            pd_regimes.each do |regime_|
              regime = PD::RegimeDecorator.new(regime_, last_regime: last_regime)
              create_treatment_from(regime) if last_regime.nil? || regime.changed?
              last_regime = regime
            end
          end

          # Note be sure not to include the regime at the start of the modality otherwise we could
          # output this as a duplicate treatment
          def pd_regimes
            regimes = Renalware::PD::RegimesInDateRangeQuery.new(
              patient: patient,
              from: modality.started_on,
              to: modality.ended_on
            ).call
            regimes - Array(pd_regime_at_start_of_modality)
          end

          def create_treatment_from(regime)
            start_date = regime.present? ? regime.start_date : modality.started_on
            end_date = regime.present? ? regime.end_date : modality.ended_on

            create_treatment(regime, start_date, end_date)
          end

          # rubocop:disable Metrics/MethodLength
          def create_treatment(regime, start_date, end_date)
            treatments << Treatment.create!(
              patient: patient,
              clinician: modality.created_by,
              started_on: start_date,
              ended_on: end_date,
              modality_id: modality.id,
              modality_description_id: modality.description_id,
              modality_code: treatment_for_pd_regime(regime),
              pd_regime_id: regime&.id
            )

            # Update the end date on the previous treatment - ie the one we just added is
            # taking over as the currently active treatment
            unless treatments.length <= 1
              previous_treatment = treatments[treatments.length - 2]
              previous_treatment.update!(ended_on: start_date)
            end
          end
          # rubocop:enable Metrics/MethodLength

          def treatments
            @treatments ||= []
          end

          def treatment_for_pd_regime(regime)
            ModalityCodeMap.new.code_for_pd_regime(regime)
          end

          def pd_patient
            Renalware::PD.cast_patient(patient)
          end
        end
      end
    end
  end
end
