class ModalityCode < ActiveRecord::Base
  include Concerns::SoftDelete

  has_many :patient_modality
  has_many :patients, :through => :patient_modality

end
