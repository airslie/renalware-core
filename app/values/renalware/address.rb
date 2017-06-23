module Renalware
  class Address < ApplicationRecord
    validates_presence_of :street_1
    validates :email, email: true, allow_blank: true
    validates_with AddressValidator

    belongs_to :addressable, polymorphic: true

    def self.reject_if_blank
      Proc.new do |attrs|
        %w(name organisation_name street_1 street_2 street_3 town county postcode)
          .all? { |a| attrs[a].blank? }
      end
    end

    def uk?
      "United Kingdom" == country
    end

    def copy_from(source)
      self.name = source.name
      self.organisation_name = source.organisation_name
      self.street_1 = source.street_1
      self.street_2 = source.street_2
      self.street_3 = source.street_3
      self.town = source.town
      self.county = source.county
      self.postcode = source.postcode
      self.country = source.country
      self
    end

    def to_s
      [name, organisation_name, street_1, street_2, street_3, town, county, postcode, country]
        .reject(&:blank?).join(", ")
    end
  end
end
