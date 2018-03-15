# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlert < ApplicationRecord
      include Accountable
      include PatientsRansackHelper
      scope :ordered, ->{ order(created_at: :desc) }
      belongs_to :patient, class_name: "Renal::Patient", touch: true
      belongs_to :action, class_name: "Renal::AKIAlertAction"
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"
      validates :patient, presence: true
      validates :max_aki, inclusion: 1..3, allow_nil: true
      alias_attribute :decided_by, :updated_by
    end
  end
end
