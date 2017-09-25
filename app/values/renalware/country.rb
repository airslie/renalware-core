# rubocop:disable Style/StructInheritance
# Countries file loaded from a csv file.
# TODO: move to database?
# Note there are two codes in the countries file:
# - alpha2 - a 2 char code in row1
# - alpha3 - a 3 char code in row2
# UKRDC want want alpha3.
module Renalware
  class Country < Struct.new(:name, :alpha2, :alpha3)
    alias :code :alpha2

    class << self
      def all
        @all ||= data.map{ |row| Country.new(row[0], row[1], row[2]) }
      end

      def data
        CSV.read(Engine.root.join("config", "countries.csv"), headers: true)
      end

      def alpha2_for(country_name)
        country = find_country(country_name)
        return unless country
        country.code
      end

      def alpha3_for(country_name)
        country = find_country(country_name)
        return unless country
        country.alpha3
      end

      def find_country(country_name)
        all.find{ |cntry| cntry.name == country_name }
      end
    end
  end
end
