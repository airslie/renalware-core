module Renalware
  module PageSize
    MAX = 100

    def self.parse(value, default:)
      size = Integer(value, exception: false)
      return default unless size&.positive?

      [size, MAX].min
    end
  end
end
