require_dependency "renalware/letters"

module Renalware
  module Letters
    class Letter < ActiveRecord::Base
      include Accountable
      extend Enumerize

      belongs_to :author, class_name: "User"
      belongs_to :patient
      belongs_to :letterhead
      has_one :recipient

      enumerize :state, in: %i(draft ready_for_review archived)
      enumerize :recipient_type, in: %i(patient doctor other)

      validates :letterhead, presence: true
      validates :author, presence: true
      validates :patient, presence: true
      validates :state, presence: true
      validates :issued_on, presence: true
      validates :description, presence: true
      validates :recipient_type, presence: true
      validates :recipient, presence: true, if: :recipient_required?

      def self.policy_class
        LetterPolicy
      end

      private

      def recipient_required?
        recipient_type.try(:other?)
      end
    end
  end
end