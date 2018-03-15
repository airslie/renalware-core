# frozen_string_literal: true

require_dependency "renalware/clinical"
require "document/base"

module Renalware
  module Clinical
    class BodyComposition < ApplicationRecord
      include PatientScope
      include Accountable

      belongs_to :patient, class_name: "Renalware::Clinical::Patient", touch: true
      belongs_to :assessor, class_name: "User", foreign_key: "assessor_id"
      belongs_to :modality_description, class_name: "Modalities::Description"

      has_paper_trail class_name: "Renalware::Clinical::Version"

      scope :ordered, -> { order(assessed_on: :desc, created_at: :desc) }

      validates :patient, presence: true
      validates :assessor, presence: true
      validates :overhydration, presence: true, numeric_inclusion: { in: -20..20 }
      validates :volume_of_distribution, presence: true, numeric_inclusion: { in: 5..150 }
      validates :total_body_water, presence: true, numeric_inclusion: { in: 0..150 }
      validates :extracellular_water, presence: true, numeric_inclusion: { in: 0..150 }
      validates :intracellular_water, presence: true, numeric_inclusion: { in: 0..150 }
      validates :lean_tissue_index, presence: true, numeric_inclusion: { in: 0..150 }
      validates :fat_tissue_index, presence: true, numeric_inclusion: { in: 0..150 }
      validates :lean_tissue_mass, presence: true, numeric_inclusion: { in: 0..150 }
      validates :fat_tissue_mass, presence: true, numeric_inclusion: { in: 0..150 }
      validates :adipose_tissue_mass, presence: true, numeric_inclusion: { in: 0..100 }
      validates :body_cell_mass, presence: true, numeric_inclusion: { in: 0..150 }
      validates :quality_of_reading, presence: true, numeric_inclusion: { in: 50..100 }
      validates :assessed_on, presence: true, timeliness: { type: :date, allow_blank: false }
    end
  end
end
