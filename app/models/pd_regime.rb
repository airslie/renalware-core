class PdRegime < ActiveRecord::Base

  belongs_to :patient

  has_many :pd_regime_bags
  has_many :bag_types, through: :pd_regime_bags

  accepts_nested_attributes_for :pd_regime_bags, allow_destroy: true

  validates :start_date, presence: true
  validates :treatment, presence: true

  with_options if: :type_apd? do |apd|
    apd.validates :last_fill_ml, allow_nil: true, numericality: { greater_than_or_equal_to: 500, less_than_or_equal_to: 5000 }
    apd.validates :tidal_percentage, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    apd.validates :no_cycles_per_apd, allow_nil: true, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 20 }
    apd.validates :overnight_pd_ml, allow_nil: true, numericality: { greater_than_or_equal_to: 3000, less_than_or_equal_to: 25000 }
  end

  def type_apd?
    if self.type.present?
      self.type == 'ApdRegime'
    end
  end

end
