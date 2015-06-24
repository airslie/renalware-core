class Practice < ActiveRecord::Base
  has_and_belongs_to_many :doctors
  belongs_to :address

  accepts_nested_attributes_for :address, allow_destroy: true

  validates_presence_of :name
  validates_presence_of :address_id
  validates_presence_of :code
end
