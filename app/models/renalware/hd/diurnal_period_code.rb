require_dependency "renalware/hd"

module Renalware
  module HD
    class DiurnalPeriodCode < ApplicationRecord
      validates :code, presence: true, uniqueness: true

      def to_s
        code
      end
    end
  end
end
