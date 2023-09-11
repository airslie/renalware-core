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
    #
    # We also take into account previous replays and and do not import a messages if has a row in a
    # 'replayed messages' table where success was indicated.
    class ReplayableHL7PathologyMessagesQuery
      include Callable
      pattr_initialize [:patient!]

      PATIENT_IDENTIFICATION_COLUMNS = %i(
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).freeze

      def call
        # .merge(never_successfully_replayed)
        complete_pathology_feed_messages
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
      # In fact what AR comes uo with using our logic below is e.g.:
      #
      # select
      #   "feed_messages" .*
      # from
      #   "feed_messages"
      # where
      #   "feed_messages"."message_type" = 'ORU'
      #   and "feed_messages"."event_type" = 'R01'
      #   and "feed_messages"."orc_order_status" = 'CM'
      #   and "feed_messages"."processed" != true
      #   and ("feed_messages"."nhs_number" = '4001540037'
      #     and ("feed_messages"."local_patient_id" = 'Z99994'
      #       or "feed_messages"."local_patient_id_5" = 'LOCAL_PATIENT_ID_5'
      #       or "feed_messages"."dob" = '1988-01-01')
      #     or "feed_messages"."dob" = '1988-01-01'
      #     and ("feed_messages"."local_patient_id" = 'Z99994'
      #       or "feed_messages"."local_patient_id_5" = 'LOCAL_PATIENT_ID_5'))
      # order by
      #   "feed_messages"."created_at" asc
      def scoped_by_patient
        scope = Message.none
        scope = scope.or(
          Message.where(nhs_number: patient.nhs_number).merge(or_where_hospital_numbers)
        )
        if patient.born_on.present?
          scope = scope.or(Message.where(dob: patient.born_on, nhs_number: patient.nhs_number))
          scope = scope.or(Message.where(dob: patient.born_on).merge(or_where_hospital_numbers))
        end
        scope
      end

      def or_where_hospital_numbers
        scope = Message.none
        PATIENT_IDENTIFICATION_COLUMNS.each do |col|
          if patient.public_send(col).present?
            scope = scope.or(Message.where(col => patient.public_send(col)))
          end
        end
        scope
      end

      # Select only complete (not partial) ORU messages that have not already been imported.
      # left join onto any previous message. We want to filter out feed messages where we
      # successfully ran a replay on this message in the past.
      def complete_pathology_feed_messages
        Renalware::Feeds::Message
          .where(
            message_type: "ORU",
            event_type: "R01",
            orc_order_status: "CM", # ie completed
            processed: [nil, false],
            feed_message_replays: { id: nil }
          )
          .joins(<<-SQL.squish)
            LEFT OUTER JOIN
              feed_message_replays
              ON feed_message_replays.message_id = feed_messages.id
              AND feed_message_replays.success = true
          SQL
      end

      # def never_successfully_replayed
      #   Renalware::Feeds::Message
      #     .joins()
      # end
    end
  end
end
