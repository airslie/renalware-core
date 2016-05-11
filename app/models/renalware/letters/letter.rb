require_dependency "renalware/letters"

module Renalware
  module Letters
    class Letter < ActiveRecord::Base
      include Accountable
      extend Enumerize

      belongs_to :author, class_name: "User"
      belongs_to :patient
      belongs_to :letterhead
      has_one :main_recipient, -> { where(role: "main") },
        class_name: "Recipient", inverse_of: :letter
      has_many :cc_recipients, -> { where(role: "cc") },
        class_name: "Recipient", dependent: :destroy, inverse_of: :letter
      has_many :recipients, dependent: :destroy


      accepts_nested_attributes_for :main_recipient
      accepts_nested_attributes_for :cc_recipients, reject_if: :all_blank, allow_destroy: true

      enumerize :state, in: %i(draft ready_for_review archived)

      validates :letterhead, presence: true
      validates :author, presence: true
      validates :patient, presence: true
      validates :state, presence: true
      validates :issued_on, presence: true
      validates :description, presence: true
      validates :main_recipient, presence: true

      def self.policy_class
        LetterPolicy
      end

      def subject?(other_patient)
        patient == other_patient
      end

      def outsider_cc_recipients
        cc_recipients.select { |cc| cc.person_role.outsider? }
      end
    end
  end
end