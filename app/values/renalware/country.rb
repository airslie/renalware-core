# rubocop:disable Style/StructInheritance
module Renalware
  class Country < Struct.new(:name, :code)

    def self.all
      @all ||= data.map{ |row| Country.new(row[0], row[1]) }
    end

    def self.data
      CSV.read(Rails.root.join("config", "countries.csv"), headers: true)
    end

    def self.code_for(country_name)
      country = all.find{ |cntry| cntry.name == country_name }
      return unless country
      country.code
    end
  end
end
