# frozen_string_literal: true

require "collection_presenter"

module Renalware
  module Letters
    module Printing
      class PrintableRecipients
        def self.for(letter)
          recipients = [letter.main_recipient]
          recipients.concat(letter.cc_recipients)
          recipients.reject do |recipient|
            recipient.statment_to_indicate_letter_will_be_emailed.present?
          end
          CollectionPresenter.new(recipients, RecipientPresenter::WithCurrentAddress)
        end
      end
    end
  end
end
