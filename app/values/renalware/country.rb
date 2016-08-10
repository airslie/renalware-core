module Renalware
  class Country < Struct.new(:name)

    def self.all
      data.map{ |d| Country.new(d[:name]) }
    end

    def self.data
      @data ||= YAML.load_file(Rails.root.join('config','countries.yml'))
    end
  end
end