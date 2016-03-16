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
          recipient.source_id = doctor.id
          recipient.name = doctor.full_name
        when "Renalware::Patient"
          recipient.source_id = patient.id
          recipient.name = patient.full_name
        end
      end

      def copy_source_address
        if source.present? && source.current_address.present?
          recipient.build_address if recipient.address.blank?
          recipient.address.copy_from(source.current_address)
          recipient.address.save!
        end
      end
    end
  end
end