require_dependency "renalware/clinical"
require "document/base"

module Renalware
  module Clinical
    class BodyComposition < ApplicationRecord
      include PatientScope
      include Accountable

      belongs_to :patient, class_name: "Renalware::Clinical::Patient"
      belongs_to :assessor, class_name: "User", foreign_key: "assessor_id"

      has_paper_trail class_name: "Renalware::Clinical::Version"

      scope :ordered, -> { order(assessed_on: :desc, created_at: :desc) }

      validates :patient, presence: true
      validates :assessor, presence: true
      validates :overhydration, presence: true
      validates :volume_of_distribution, presence: true
      validates :total_body_water, presence: true
      validates :extracellular_water, presence: true
      validates :intracellular_water, presence: true
      validates :lean_tissue_index, presence: true
      validates :fat_tissue_index, presence: true
      validates :lean_tissue_mass, presence: true
      validates :fat_tissue_mass, presence: true
      validates :adipose_tissue_mass, presence: true
      validates :body_cell_mass, presence: true
      validates :quality_of_reading, presence: true
      validates :assessed_on, presence: true
      validates :assessed_on, timeliness: { type: :date, allow_blank: false }
    end
  end
end
