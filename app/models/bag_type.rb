class BagType < ActiveRecord::Base
  acts_as_paranoid

  has_many :pd_regime_bags

  validates :description, presence: true
end
