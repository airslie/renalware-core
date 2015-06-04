class BagType < ActiveRecord::Base
  acts_as_paranoid

  validates :description, presence: true
end
