class PdRegimeBag < ActiveRecord::Base

  before_save :assign_days_per_week

  belongs_to :bag_type
  belongs_to :pd_regime

  validates :volume, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 10000 }

  def initialize(attributes = nil, options = {})
    super
    days_to_sym.each do |day|
      self.send(:"#{day}=", true)
    end
    self.attributes = attributes unless attributes.nil?
  end

  def assign_days_per_week
    self.per_week = days.keep_if { |d| d == true }.size
  end

  def days
    days_to_sym.map do |day|
      self.send(day)
    end
  end

  def days_to_sym
    Date::DAYNAMES.map { |n| n.underscore.to_sym }
  end

end
