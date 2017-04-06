require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class DonorStage < ApplicationRecord
      include Accountable
      include PatientScope

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :donor_stage_position
      belongs_to :donor_stage_status
      validates :patient, presence: true
      validates :donor_stage_position, presence: true
      validates :donor_stage_status, presence: true
      validates :started_on, presence: true

      scope :current, ->{ where(terminated_on: nil) }
      scope :ordered, ->{ order(terminated_on: :desc, started_on: :desc) }
    end
  end
end
