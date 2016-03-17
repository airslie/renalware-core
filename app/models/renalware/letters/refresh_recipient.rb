module Renalware
  module Letters
    class RefreshRecipient
      attr_reader :recipient

      def initialize(recipient)
        @recipient = recipient
      end

      def call
        assign_doctor_or_patient
        copy_source_address

        recipient.save
      end

      private

      def letter
        recipient.letter
      end

      def patient
        letter.patient
      end

      def doctor
        patient.doctor
      end

      def source
        recipient.source
      end

      def assign_doctor_or_patient
        case recipient.source_type
        when "Renalware::Doctor"
          assign_recipient_attributes(doctor)
        when "Renalware::Patient"
          assign_recipient_attributes(patient)
        end
      end

      def assign_recipient_attributes(source)
        recipient.source_id = source.id
        recipient.name = source.full_name
      end

      def copy_source_address
        if source.try(:current_address).present?
          recipient.copy_address!(source.current_address)
        end
      end
    end
  end
end