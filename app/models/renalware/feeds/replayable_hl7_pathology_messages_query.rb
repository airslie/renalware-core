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
    # messages really (although appointment info could be useful?), and might in fact lead to
    # confusion.
    #
    # We also take into account previous replays and and do not import a messages if has a row in a
    # 'replayed messages' table where success was indicated.
    class ReplayableHL7PathologyMessagesQuery
      include Callable
      pattr_initialize [:patient!]

      class MissingNHSNumberError < StandardError; end
      class MissingDOBNumberError < StandardError; end

      # PATIENT_IDENTIFICATION_COLUMNS = %i(
      #   local_patient_id
      #   local_patient_id_2
      #   local_patient_id_3
      #   local_patient_id_4
      #   local_patient_id_5
      # ).freeze

      def call
        raise MissingNHSNumberError if patient.nhs_number.blank?
        raise MissingDOBNumberError if patient.born_on.blank?

        ids = feed_message_ids(nhs_number: patient.nhs_number, dob: patient.born_on.to_s)
        Renalware::Feeds::Message.where(id: ids).order(sent_at: :asc)
      end

      private

      # Get a distinct feed message for each orc_filler_order_number, talking the most recently
      # sent one. Return an array of matching ids.
      # rubocop:disable Metrics/MethodLength
      def feed_message_ids(nhs_number:, dob:)
        sql = <<-SQL.squish
          SELECT distinct on (orc_filler_order_number) fm.id
            FROM renalware.feed_messages fm
            LEFT OUTER JOIN renalware.feed_message_replays fmr
              ON fmr.message_id = fm.id
              AND fmr.success = true
            WHERE
              message_type = 'ORU'
              AND event_type = 'R01'
              AND nhs_number = ?
              AND dob = ?
              AND sent_at IS NOT NULL
              AND fmr.id IS NULL
            ORDER BY
              orc_filler_order_number, sent_at desc
        SQL
        sql = ActiveRecord::Base.sanitize_sql_array(
          [
            sql,
            nhs_number,
            dob
          ]
        )
        ActiveRecord::Base.connection.execute(sql)&.values&.flatten
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end

# sql = <<-SQL.squish
#           with final_oru_messages as (
#             SELECT distinct on (orc_filler_order_number) fm.id
#               FROM renalware.feed_messages fm
#               LEFT OUTER JOIN renalware.feed_message_replays fmr
#                 ON fmr.message_id = fm.id
#                 AND fmr.success = true
#               WHERE
#                 message_type = 'ORU'
#                 AND event_type = 'R01'
#                 AND nhs_number = ?
#                 AND dob = ?
#                 AND sent_at IS NOT NULL
#               ORDER BY
#                 orc_filler_order_number, sent_at desc
#           )
#           select fm1.*
#             from feed_messages fm1
#             inner join final_oru_messages using(id)
#             order by fm1.sent_at asc
#         SQL
