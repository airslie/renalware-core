module Renalware
  module Letters
    class RefreshMainRecipient
      attr_reader :main_recipient

      def initialize(main_recipient)
        @main_recipient = main_recipient
      end

      def call
        set_doctor_or_patient_as_source
        copy_source_address

        main_recipient.save
      end

      private

      def set_doctor_or_patient_as_source
        assign_source(doctor) if main_recipient.doctor?
        assign_source(patient) if main_recipient.patient?
      end

      def assign_source(source)
        main_recipient.source = source
        main_recipient.name = source.full_name
      end

      def copy_source_address
        if source.try(:current_address).present?
          main_recipient.copy_address!(source.current_address)
        end
      end

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
    end
  end
end