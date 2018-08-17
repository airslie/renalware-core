# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class PersistMessage
      # hl7_message is an HL7Message (a decorator around ::HL7::Message)
      # If the same message is persisted twice we'll get an ActiveRecord::RecordNotUnique error
      # but that's fine as we don't want to process the same HL7 message twice.
      def call(hl7_message)
        Message.create!(
          event_code: hl7_message.type,
          header_id: hl7_message.header_id,
          body: hl7_message.to_s,
          body_hash: Digest::MD5.hexdigest(hl7_message.to_s),
          patient_identifier: hl7_message.patient_identification&.internal_id
        )
      end
    end
  end
end
