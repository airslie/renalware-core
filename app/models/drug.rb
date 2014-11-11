class Drug < ActiveRecord::Base
  include Concerns::SoftDelete

  has_many :drugs_patients
  has_many :patients, :through => :drugs_patients

  validates :name, presence: true

  def display_type
    "Standard Drug"
  end
end
