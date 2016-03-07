require_dependency "renalware/letters"

module Renalware
  module Letters
    class BaseLetter < ActiveRecord::Base
      self.table_name = 'letter_letters'

      include LetterType

      belongs_to :author, class_name: 'User'
      belongs_to :reviewer, class_name: 'User'
      belongs_to :doctor
      belongs_to :patient
      belongs_to :description
      belongs_to :recipient_address, class_name: 'Address'

      validates_with AuthorSignatureValidator
      validates_presence_of :author
      validates_presence_of :patient
      validates_presence_of :recipient
      validates_presence_of :recipient_address
      validates_presence_of :description_id
      validates_presence_of :state, in: [:draft, :review] # TODO: Final states TBC.

      def self.policy_class
        LetterPolicy
      end

      def title
        self.class.name.underscore.titleize.gsub("Renalware/Letters/", "")
      end

      def to_partial_path
        'letters/letter'
      end
    end
  end
end