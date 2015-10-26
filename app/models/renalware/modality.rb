module Renalware
  class Modality < ActiveRecord::Base

    acts_as_paranoid

    belongs_to :modality_code
    belongs_to :patient
    belongs_to :modality_reason

    validates :start_date, presence: true

    scope :ordered, -> { order('termination_date DESC') }

    def transfer!(attrs)
      transaction do
        successor = Modality.create!(attrs)
        self.termination_date = successor.start_date
        self.save!
        self.destroy!
        successor
      end
    end
  end
end
