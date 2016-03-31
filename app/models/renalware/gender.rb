module Renalware
  class Gender
    include ActiveModel::Model

    DATA = {
      "NK" => "Not Known",
      "M" => "Male",
      "F" => "Female",
      "NS" => "Not Specified"
    }.freeze

    def self.all
      DATA.map {|code, _| self.new(code) }
    end

    # @section serialization
    #
    def self.load(raw_string)
      self.new(raw_string)
    end

    def self.dump(gender)
      gender.to_str
    end

    def initialize(code)
      @code = code
    end

    # @section validations
    #
    validates :code, inclusion: { in: DATA.keys }

    # @section attributes
    #
    attr_reader :code

    def name
      DATA[@code]
    end

    # @section coercions
    #
    def to_s
      name.to_s
    end

    def to_str
      @code
    end
  end
end
