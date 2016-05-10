module Renalware
  class Address < ActiveRecord::Base
    validates_presence_of :street_1
    validates_with AddressValidator

    def self.reject_if_blank
      Proc.new do |attrs|
        !%i(name organisation_name street_1 street_2 city county postcode).map{|a| attrs[a].blank?}.include?(false)
      end
    end

    def uk?
      'United Kingdom' == country
    end

    def copy_from(source)
      self.name = source.name
      self.organisation_name = source.organisation_name
      self.street_1 = source.street_1
      self.street_2 = source.street_2
      self.city = source.city
      self.county = source.county
      self.postcode = source.postcode
      self.country = source.country
      self
    end

    def to_s
      [name, organisation_name, street_1, street_2, city, county, postcode, country].reject(&:blank?).join(", ")
    end
  end
end