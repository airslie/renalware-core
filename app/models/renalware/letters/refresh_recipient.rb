module Renalware
  module Letters
    class RefreshRecipient
      def self.build
        self.new
      end

      def call(recipient)
        return if recipient.manual?
        @recipient = recipient

        assign_source
        copy_source_name
        copy_source_address

        @recipient.save
      end

      private

      def assign_source
        if @recipient.patient?
          @recipient.source = @recipient.letter.patient
        elsif @recipient.doctor?
          @recipient.source = @recipient.letter.patient.doctor
        else
          raise "Unknown source_type"
        end
      end

      def copy_source_name
        @recipient.name = @recipient.source.full_name
      end

      def copy_source_address
        address = @recipient.source.current_address
        return if address.blank?

        @recipient.build_address if @recipient.address.blank?
        @recipient.address.copy_from(address).save!
      end
    end
  end
end