module Renalware
  class Gender
    include ActiveModel::Model

    DATA = {
      "NK" => "Not Known",
      "M" => "Male",
      "F" => "Female",
      "NS" => "Not Specified"
    }.freeze

    SALUTATIONS = {
      "NK" => "",
      "M" => "Mr",
      "F" => "Mme",
      "NS" => ""
    }.freeze

    def self.all
      DATA.map { |code, _| new(code) }
    end

    # @section serialization
    #
    def self.load(raw_string)
      new(raw_string)
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

    def code
      ActiveSupport::StringInquirer.new(@code)
    end

    def name
      DATA[@code]
    end

    def salutation
      SALUTATIONS[@code]
    end

    # @section coercions
    #
    def to_s
      @code
    end

    def to_str
      @code
    end
  end
end
