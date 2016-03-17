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

      accepts_nested_attributes_for :main_recipient

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

      private

      def apply_defaults
        add_doctor_as_default_main_recipient
      end

      def add_doctor_as_default_main_recipient
        build_main_recipient(source_type: Doctor.name) if main_recipient.blank?
      end
    end
  end
end