module Renalware
  class BaseLetter < ActiveRecord::Base
    self.table_name = 'letters'

    include LetterType

    belongs_to :author, class_name: 'User'
    belongs_to :reviewer, class_name: 'User'
    belongs_to :doctor
    belongs_to :patient
    belongs_to :letter_description
    belongs_to :recipient_address, class_name: 'Address'

    validates_with LetterSignatureValidator
    validates_presence_of :patient
    validates_presence_of :recipient
    validates_presence_of :recipient_address
    validates_presence_of :letter_description_id
    validates_presence_of :state, in: [:draft, :review] # TODO: Final states TBC.

    def self.policy_class
      LetterPolicy
    end

    def title
      self.class.name.underscore.titleize.gsub("Renalware/", "")
    end

    def to_partial_path
      'letters/letter'
    end
  end
end