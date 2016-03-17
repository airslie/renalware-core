module Renalware
  module Letters
    class RefreshMainRecipient
      attr_reader :main_recipient

      def initialize(main_recipient)
        @main_recipient = main_recipient
      end

      def call
        assign_doctor_or_patient
        copy_source_address

        main_recipient.save
      end

      private

      def letter
        main_recipient.letter
      end

      def patient
        letter.patient
      end

      def doctor
        patient.doctor
      end

      def source
        main_recipient.source
      end

      def assign_doctor_or_patient
        case main_recipient.source_type
        when "Renalware::Doctor"
          assign_main_recipient_attributes(doctor)
        when "Renalware::Patient"
          assign_main_recipient_attributes(patient)
        end
      end

      def assign_main_recipient_attributes(source)
        main_recipient.source_id = source.id
        main_recipient.name = source.full_name
      end

      def copy_source_address
        if source.try(:current_address).present?
          main_recipient.copy_address!(source.current_address)
        end
      end
    end
  end
end