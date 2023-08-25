# frozen_string_literal: true

module Renalware
  module Feeds
    # When a new patient is added to Renalware, its possible and likely we will have received
    # HL7 messages for them at some point in the past given that we store all ADT (demographics)
    # and ORU (pathology) messages for all patients in the hospital, routed via our Mirth server.
    # So it would be nice to replay a patient's historical messages, but this time, instead of
    # ignoring their content because the patient is not in Renalware, they will be imported and
    # associated with the patient.
    #
    # This query object finds feed_messages that
    # - relate to the supplied patient
    # - have not been imported yet
    # and replays them.
    # We can in theory replay ADT or ORU messages but currently do only ORU (pathology) because it
    # it is deemed that once the patient is added to Renalware, subsequent ADT HL7 messages which
    # will soon arrive will being the demographic data up to date - so no point replaying ADT
    # messages really, and might in fact lead to confusion.
    class ReplayableHL7PathologyMessagesQuery
      include Callable
      pattr_initialize [:patient!]

      PATIENT_IDENTIFICATION_COLUMNS = %i(
        nhs_number
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).freeze

      def call
        final_pathology_feed_messages
          .merge(scoped_by_patient)
          .order(created_at: :asc)
      end

      private

      # We want to find results hitting at least 2-out-of-3 search terms
      # - nhs_number and any hosp number
      # - nhs_number and dob
      # - hosp number and dob
      #
      # e.g.
      #   where
      #   (
      #     fm.nhs_number = p.nhs_number
      #     and (
      #       fm.local_patient_id = p.local_patient_id or
      #       fm.local_patient_id_2 = p.local_patient_id_2 or etc...
      #     )
      #   )
      #   or (
      #     fm.nhs_number = p.nhs_number
      #     and fm.dob = p.born_on
      #   )
      #   or
      #   (
      #     (
      #       fm.local_patient_id = p.local_patient_id or
      #       fm.local_patient_id_2 = p.local_patient_id_2 or etc..
      #     )
      #     and fm.dob = p.born_on
      #  )
      #
      def scoped_by_patient
        scope = Renalware::Feeds::Message.none
        scope.or(
          Message
            .where(nhs_number: patient.nhs_number)
            .and(hospital_numbers_where_clause)
        )
        if patient.born_on.present?
          scope.or(
            Message
              .where(dob: patient.born_on, nhs_number: patient.nhs_number)
          )
          scope.or(
            Message
              .where(dob: patient.born_on)
              .and(hospital_numbers_where_clause)
          )
        end
        scope
      end

      def hospital_numbers_where_clause
        PATIENT_IDENTIFICATION_COLUMNS.each do |col|
          if patient.public_send(col).present?
            scope = scope.or(Message.where(col => patient.public_send(col)))
          end
        end
      end

      def final_pathology_feed_messages
        Renalware::Feeds::Message
          .where(message_type: "ORU", event_type: "R01")
          .where(orc_order_status: "CM") # ie completed
          .where.not(processed: true) # could be nil or false
      end
    end
  end
end
