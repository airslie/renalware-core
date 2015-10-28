module Renalware
  class Modality < ActiveRecord::Base

    acts_as_paranoid

    belongs_to :modality_code
    belongs_to :patient
    belongs_to :modality_reason

    validates :start_date, presence: true

    scope :ordered, -> { order(end_date: :desc) }

    def transfer!(attrs)
      transaction do
        successor = Modality.create!(attrs)
        self.end_date = successor.start_date
        self.save!
        self.destroy!
        successor
      end
    end
  end
end
