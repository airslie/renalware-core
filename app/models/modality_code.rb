class ModalityCode < ActiveRecord::Base
  include Concerns::SoftDelete

  has_many :modalities
  has_many :patients, :through => :modalities

end
