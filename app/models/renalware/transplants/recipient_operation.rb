require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientOperation < ActiveRecord::Base
      include Document::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient

      scope :ordered, -> { order(performed_on: :asc) }
      scope :reversed, -> { order(performed_on: :desc) }

      has_paper_trail class_name: "Renalware::Transplants::RecipientOperationVersion"
      has_document class_name: "RecipientOperationDocument"

      validates :performed_on, presence: true
      validates :theatre_case_start_time, presence: true
      validates :donor_kidney_removed_from_ice_at, presence: true
      validates :kidney_perfused_with_blood_at, presence: true
      validates :operation_type, presence: true
      validates :transplant_site, presence: true
      validates :cold_ischaemic_time, presence: true

      validates :donor_kidney_removed_from_ice_at, timeliness: { type: :datetime }
      validates :kidney_perfused_with_blood_at, timeliness: { type: :datetime }
      validates :theatre_case_start_time, timeliness: { type: :time }
      validates :cold_ischaemic_time, timeliness: { type: :time }

      enumerize :operation_type, in: %i(kidney kidney_pancreas pancreas kidney_liver liver)
    end
  end
end