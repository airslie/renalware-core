class Modality < ActiveRecord::Base

  acts_as_paranoid

  belongs_to :modality_code
  belongs_to :patient
  belongs_to :modality_reason

  validates :start_date, presence: true

  # @section services
  #
  def transfer!(attrs)
    transaction do
      self.termination_date = attrs[:start_date]
      self.save!
      self.destroy!
      successor = Modality.create!(attrs)
      successor
    end
  end
end
