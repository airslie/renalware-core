class ModalityCode < ActiveRecord::Base
  acts_as_paranoid

  has_many :modalities
  has_many :patients, :through => :modalities

  def death?
    name == 'Death'
  end

end
