class PeritonitisEpisode < ActiveRecord::Base
  belongs_to :patient

  belongs_to :organism_1, :class_name => "OrganismCode", :foreign_key => :organism_1_id
  belongs_to :organism_2, :class_name => "OrganismCode", :foreign_key => :organism_2_id

  has_many :medication_routes, as: :administerable

  validate :number_of_medication_routes

  def number_of_medication_routes
    unless medication_routes.any? && medication_routes.size == 5
      errors.add(:medication_routes, "Must have 5")
    end
  end

end
