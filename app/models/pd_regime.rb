class PdRegime < ActiveRecord::Base

  belongs_to :patient

  has_many :pd_regime_bag
  has_many :bag_types, through: :pd_regime_bag

  validates :start_date, presence: true

end
