class BagType < ActiveRecord::Base
  acts_as_paranoid

  has_many :pd_regime_bags

  validates :description, presence: true
  validates :glucose_grams_per_litre, presence: true

  validates :glucose_grams_per_litre, numericality: { allow_nil: true, greater_than_or_equal_to: 10, less_than_or_equal_to: 50 }

  def full_description
    [manufacturer, description].join(' ')
  end
end
