class PdRegime < ActiveRecord::Base

  belongs_to :patient

  has_many :pd_regime_bags
  has_many :bag_types, through: :pd_regime_bag

  accepts_nested_attributes_for :pd_regime_bags
end
