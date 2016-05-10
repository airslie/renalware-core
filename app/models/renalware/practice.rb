module Renalware
  class Practice < ActiveRecord::Base
    has_and_belongs_to_many :doctors
    has_one :address, as: :addressable

    accepts_nested_attributes_for :address, allow_destroy: true

    validates_presence_of :name
    validates_presence_of :address
    validates_presence_of :code
  end
end