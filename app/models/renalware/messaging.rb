# frozen_string_literal: true

module Renalware
  module Messaging
    module_function

    def table_name_prefix = "messaging_"

    def cast_patient(patient)
      ActiveType.cast(
        patient,
        ::Renalware::Messaging::Patient,
        force: Renalware.config.force_cast_active_types
      )
    end

    def cast_author(author)
      ActiveType.cast(
        author,
        ::Renalware::Messaging::Author,
        force: Renalware.config.force_cast_active_types
      )
    end

    module Internal
      module_function

      def cast_patient(patient)
        ActiveType.cast(
          patient,
          ::Renalware::Messaging::Internal::Patient,
          force: Renalware.config.force_cast_active_types
        )
      end

      def cast_author(author)
        ActiveType.cast(
          author,
          ::Renalware::Messaging::Internal::Author,
          force: Renalware.config.force_cast_active_types
        )
      end

      def cast_recipient(recipient)
        ActiveType.cast(
          recipient,
          ::Renalware::Messaging::Internal::Recipient,
          force: Renalware.config.force_cast_active_types
        )
      end
    end
  end
end
