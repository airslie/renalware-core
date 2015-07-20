class PdRegimeBag < ActiveRecord::Base

  before_save :assign_days_per_week

  belongs_to :bag_type
  belongs_to :pd_regime

  validates :volume, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 10000 }

end
