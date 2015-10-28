module Renalware
  class Modality < ActiveRecord::Base

    acts_as_paranoid

    belongs_to :modality_code
    belongs_to :patient
    belongs_to :modality_reason

    validates :started_on, presence: true

    scope :ordered, -> { order(ended_on: :desc) }

    def transfer!(attrs)
      transaction do
        successor = Modality.create!(attrs)
        self.ended_on = successor.started_on
        self.save!
        self.destroy!
        successor
      end
    end
  end
end
