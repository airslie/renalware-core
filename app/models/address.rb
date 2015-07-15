class Address < ActiveRecord::Base
  validates_presence_of :street_1, :postcode

  def self.reject_if_blank
    Proc.new do |attrs|
      attrs[:street_1].blank? && attrs[:street_2].blank? &&
      attrs[:city].blank? && attrs[:county].blank? &&
      attrs[:postcode].blank?
    end
  end

  alias_method :orig_to_s, :to_s

  def to_s(*fields)
    if fields.any?
      fields.map { |f| send(f) }.compact.join(', ')
    else
      orig_to_s
    end
  end
end
