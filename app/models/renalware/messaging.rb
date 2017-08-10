require_dependency "renalware"

module Renalware
  module Messaging
    def self.table_name_prefix
      "messaging_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Messaging::Patient)
    end

    def self.cast_author(author)
      ActiveType.cast(author, ::Renalware::Messaging::Author)
    end

    def self.cast_recipient(recipient)
      ActiveType.cast(recipient, ::Renalware::Messaging::Recipient)
    end
  end
end
