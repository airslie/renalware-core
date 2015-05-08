class ExitSiteInfection < ActiveRecord::Base

  belongs_to :patient

  has_many :medications, as: :treatable
  has_many :medication_routes, through: :medications
  has_many :patients, through: :medications, as: :treatable
  has_many :infection_organisms, as: :infectable
  has_many :organism_codes, through: :infection_organisms, as: :infectable


end
