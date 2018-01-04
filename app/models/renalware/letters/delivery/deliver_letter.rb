require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      # Responsible for delivering the letter according to recipient's preferred method
      # Scenarios
      # - Main recipient is GP so email the GP and snailmail any CCs
      # - Main recipient is patient/contact and GP is a CC, so again email GP and snailmail others
      class DeliverLetter
        pattr_initialize [:letter!]
        delegate :gp, :others, to: :filtered_recipients

        def call
          PrimaryCarePhysicianMailer.patient_letter(letter, gp).deliver if gp.present?
          PostLetterToRecipients.call(letter, others) if others.any?
        end

        # Helper class to split out GP and other recipients
        class RecipientFilter
          pattr_initialize [:recipients!]

          def gp
            @gp ||= recipients.find(&:primary_care_physician?)
          end

          def others
            @others ||= recipients.reject(&:primary_care_physician?)
          end
        end

        private

        def filtered_recipients
          @filtered_recipients ||= RecipientFilter.new(recipients: letter.recipients)
        end
      end
    end
  end
end
