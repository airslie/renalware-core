class ExitSiteInfection < ActiveRecord::Base

  belongs_to :patient

  has_many :medications, as: :treatable
  has_many :medication_routes, through: :medications
  has_many :patients, through: :medications, as: :treatable
  has_many :infection_organisms, as: :infectable
  has_many :organism_codes, through: :infection_organisms, as: :infectable

  accepts_nested_attributes_for :medications, allow_destroy: true,
  reject_if: proc { |attrs| attrs[:dose].blank? && attrs[:notes].blank? && attrs[:frequency].blank? }

  accepts_nested_attributes_for :infection_organisms, allow_destroy: true,
  reject_if: proc { |attrs| attrs[:sensitvity].blank? && attrs[:organism_code_id].blank? }

end
