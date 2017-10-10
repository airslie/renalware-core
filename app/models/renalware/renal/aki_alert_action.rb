require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlertAction < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      delegate :to_s, to: :name
    end
  end
end
