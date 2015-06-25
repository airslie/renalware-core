class Address < ActiveRecord::Base
  validates_presence_of :street_1, :postcode

  def self.reject_if_blank
    Proc.new do |attrs|
      attrs[:street_1].blank? && attrs[:street_2].blank? &&
      attrs[:city].blank? && attrs[:county].blank? &&
      attrs[:postcode].blank?
    end
  end
end
