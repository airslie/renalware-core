require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class Message < ApplicationRecord
      validates :body, presence: true
      validates :subject, presence: true
      validates :author, presence: true
      validates :patient, presence: true
      validates :sent_at, presence: true

      belongs_to :patient
      belongs_to :author
      belongs_to :replying_to_message, class_name: name
      has_many :receipts
      has_many :recipients, through: :receipts
    end
  end
end
