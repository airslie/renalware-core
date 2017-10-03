require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlertAction < ApplicationRecord
      validates :name, presence: true, uniqueness: true
    end
  end
end
