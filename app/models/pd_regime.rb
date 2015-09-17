class PdRegime < ActiveRecord::Base

  belongs_to :patient

  has_many :pd_regime_bags
  has_many :bag_types, through: :pd_regime_bags

  accepts_nested_attributes_for :pd_regime_bags, allow_destroy: true

  validates :start_date, presence: true

  scope :current, -> { order('created_at DESC').limit(1) }
end
