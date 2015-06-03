class BagType < ActiveRecord::Base
  validates :description, presence: true
end
