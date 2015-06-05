class PdRegime < ActiveRecord::Base

  has_many :pd_regime_bag
  has_many :bag_types, through: :pd_regime_bag

end
