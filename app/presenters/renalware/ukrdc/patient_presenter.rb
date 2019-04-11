# frozen_string_literal: true

require_dependency "renalware"

# rubocop:disable Metrics/ClassLength
module Renalware
  module UKRDC
    class PatientPresenter < SimpleDelegator
      UKRDC_MAX_PHONE_LEN = 80
      attr_reader :changes_since, :changes_up_until
      delegate :profile, to: :renal_patient, allow_nil: true
      delegate :first_seen_on, to: :profile, allow_nil: true

      # rubocop:disable Metrics/MethodLength
      def initialize(patient, changes_since: nil)
        if changes_since.present? && changes_since.is_a?(String)
          changes_since = Time.zone.parse(changes_since)
        end
        # TODO: document what's happening here with dates
        @changes_since = changes_since ||
                         patient.sent_to_ukrdc_at ||
                         Renalware.config.ukrdc_default_changes_since_date
        if @changes_since.blank?
          raise(
            ArgumentError,
            "No date for comparison: patient#sent_to_ukrdc_at and changes_since are nil"
          )
        end
        @changes_up_until = Time.zone.now
        super(patient)
      end
      # rubocop:enable Metrics/MethodLength

      def language
        return if super.nil? || super.name == "Unknown"

        super
      end

      def modalities
        __getobj__.modalities.order(started_on: :asc)
      end

      def dead?
        current_modality_death?
      end

      def current_modality_hd?
        return false if current_modality.blank?

        current_modality.description.is_a?(Renalware::HD::ModalityDescription)
      end

      def smoking_history
        @smoking_history ||= document.history&.smoking&.upcase
      end

      def letters
        CollectionPresenter.new(
          letters_patient
            .letters
            .approved_or_completed
            .includes(:updated_by, :author, :letterhead, :archive)
            .where("updated_at > ?", changes_since),
          Renalware::Letters::LetterPresenterFactory
        )
      end

      def finished_hd_sessions
        hd_patient
          .finished_hd_sessions
          .includes(:patient, :dialysate, :updated_by)
          .where("hd_sessions.updated_at > ?", changes_since)
      end

      def current_registration_status_rr_code
        @current_registration_status_rr_code ||= begin
          status = transplant_patient.current_registration_status
          status&.description&.rr_code
        end
      end

      def hospital_unit_code
        letter_head.site_code
      end

      def allergies
        clinical_patient
          .allergies
          .where("recorded_at >= ?", changes_since)
      end

      def clinic_visits
        clinics_patient
          .clinic_visits
          .where("date >= ?", changes_since)
          .includes(:updated_by)
      end

      # We always send the patients current prescriptions.
      def prescriptions
        __getobj__.prescriptions.current.includes(:termination, :medication_route, :drug)
      end

      # We want to avoid returning duplicate pathology_observation_requests. We might have had
      # and update to a pathology_observation_requests, adding a previously missing result,
      # and the requestor_order_number is the same, so we have two rows with the same
      # patient_id and requestor_order_number. We want to just select that latest one. We'll use
      # created_at for this, even though it would be more accurate to look at the timestamp in the
      # OBR or MSH segment (these not currently available).
      # We use fully qualified column names here to prevent SQL errors when AR compiles the SQL.
      def latest_observation_requests
        Pathology::ObservationRequest
          .select(<<-SELECT)
          DISTINCT ON (
            pathology_observation_requests.patient_id,
            pathology_observation_requests.requestor_order_number)
          *
          SELECT
          .order(<<-ORDER)
            pathology_observation_requests.patient_id ASC,
            pathology_observation_requests.requestor_order_number ASC,
            pathology_observation_requests.created_at DESC
          ORDER
      end

      def observation_requests
        latest_observation_requests
          .where(patient_id: id)
          .where("requested_at >= ?", changes_since)
          .where("loinc_code is not null")
          .eager_load(
            :description,
            observations: { description: :measurement_unit }
          )
      end

      private

      def clinical_patient
        @clinical_patient ||= Renalware::Clinical.cast_patient(__getobj__)
      end

      def clinics_patient
        @clinics_patient ||= Renalware::Clinics.cast_patient(__getobj__)
      end

      def letters_patient
        @letters_patient ||= Renalware::Letters.cast_patient(__getobj__)
      end

      def pathology_patient
        @pathology_patient ||= Renalware::Pathology.cast_patient(__getobj__)
      end

      def renal_patient
        @renal_patient ||= Renalware::Renal.cast_patient(__getobj__)
      end

      def transplant_patient
        @transplant_patient ||= Renalware::Transplants::PatientPresenter.new(__getobj__)
      end

      def hd_patient
        @hd_patient ||= Renalware::HD::PatientPresenter.new(self)
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
