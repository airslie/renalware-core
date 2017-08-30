require_dependency "renalware/hd"

module Renalware
  module HD
    class DiurnalPeriodCode < ApplicationRecord
      validates :code, presence: true, uniqueness: true
    end
  end
end
