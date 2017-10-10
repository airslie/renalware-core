require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlert < ApplicationRecord
      include Accountable
      scope :ordered, ->{ order(created_at: :desc) }
      belongs_to :patient, class_name: "Renal::Patient"
      belongs_to :action, class_name: "Renal::AKIAlertAction"
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"
      validates :patient, presence: true
      alias_attribute :decided_by, :updated_by
    end
  end
end
