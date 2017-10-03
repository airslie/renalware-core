require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlert < ApplicationRecord
      include Accountable
      scope :ordered, ->{ order(created_at: :desc) }
      belongs_to :patient, class_name: "Renal::Patient"
      validates :patient, presence: true
    end
  end
end
