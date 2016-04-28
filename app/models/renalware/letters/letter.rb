require_dependency "renalware/letters"

module Renalware
  module Letters
    class Letter < ActiveRecord::Base
      include Accountable
      extend Enumerize

      belongs_to :author, class_name: "User"
      belongs_to :patient
      belongs_to :letterhead
      has_one :main_recipient
      has_many :cc_recipients, dependent: :destroy
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

      def self.build(attributes={})
        new(attributes).tap do |letter|
          letter.build_main_recipient(source_type: Doctor.name) if letter.main_recipient.blank?
        end
      end

      def manual_cc_recipients
        cc_recipients.select { |cc| !cc.automatic? }
      end

      def refresh!
        RefreshLetter.new(self).call
      end
    end
  end
end