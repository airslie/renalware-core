require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    class Postman
      class Recipients
        pattr_initialize [:recipients!]

        def gp
          @gp ||= recipients.find(&:primary_care_physician?)
        end

        def others
          @others ||= recipients.reject(&:primary_care_physician?)
        end
      end

      # Scenarios
      # - main_recipient is GP so email them and remove and snail-mail the CCs
      # - main_recipient is someone else but we CC the GP via email and remove them from
      #   the snail-mail CCs
      #   letter.main_recipient.primary_care_physician?
      #   letter.cc_recipients
      def letter_approved(letter)
        recipients = Recipients.new(recipients: letter.recipients)
        EmailLetterToGP.call(letter, recipients.gp) if recipients.gp.present?
        PostLetterToRecipients.call(letter, recipients.others) if recipients.others.any?
      end
    end
  end
end
