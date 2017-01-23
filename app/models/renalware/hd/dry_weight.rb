require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class DryWeight < ApplicationRecord
      include PatientScope
      include Accountable

      belongs_to :patient
      belongs_to :assessor, class_name: "User", foreign_key: "assessor_id"

      has_paper_trail class_name: "Renalware::HD::Version"

      scope :ordered, -> { order(assessed_on: :desc, created_at: :desc) }

      validates :patient, presence: true
      validates :assessor, presence: true
      validates :weight, presence: true, "renalware/patients/weight" => true
      validates :assessed_on, presence: true
      validates :assessed_on, timeliness: { type: :date, allow_blank: false }
    end
  end
end
