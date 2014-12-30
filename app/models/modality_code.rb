class ModalityCode < ActiveRecord::Base
  include Concerns::SoftDelete

  has_many :patient_modalities
  has_many :patients, :through => :patient_modalities

end
