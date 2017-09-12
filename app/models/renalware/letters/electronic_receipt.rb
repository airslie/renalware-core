require_dependency "renalware/letters"

# Represents an Electronic CC - a reference to a letter sent to a recipient (another user on the
# system) as a 'CC'. We use the concept of a 'receipt' which, while mainly being a cross table
# between letter and recipient user, is also a well-named place to store related information
# for example whether the message has been read (e.g. the letter viewed).
module Renalware
  module Letters
    class ElectronicReceipt < ApplicationRecord
      belongs_to :letter
      belongs_to :recipient, class_name: "Renalware::User"
      validates :letter, presence: true
      validates :recipient_id, presence: true

      scope :unread, -> { where(read_at: nil) }

      def read?
        read_at.present?
      end
    end
  end
end
