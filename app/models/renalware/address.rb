module Renalware
  class Address < ActiveRecord::Base
    validates_presence_of :street_1
    validates_with AddressValidator

    def self.reject_if_blank
      Proc.new do |attrs|
        !%i(street_1 street_2 city county postcode).map{|a| attrs[a].blank?}.include?(false)
      end
    end

    def uk?
      'United Kingdom' == country
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
end