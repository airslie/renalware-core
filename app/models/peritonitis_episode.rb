class PeritonitisEpisode < ActiveRecord::Base
  belongs_to :patient

  has_many :infection_organisms, as: :infectable
  has_many :organism_codes, through: :infection_organisms, as: :infectable

  has_many :medication_routes, as: :administerable

  validate :number_of_medication_routes

  def number_of_medication_routes
    unless medication_routes.any? && medication_routes.size == 5
      errors.add(:medication_routes, "Must have 5")
    end
  end

end
