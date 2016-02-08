require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class Session < ActiveRecord::Base
      include Document::Base
      include PatientScope
      include Accountable

      belongs_to :patient
      belongs_to :modality_description
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :signed_on_by, class_name: "User", foreign_key: "signed_on_by_id"
      belongs_to :signed_off_by, class_name: "User", foreign_key: "signed_off_by_id"

      has_document class_name: "Renalware::HD::SessionDocument"
      has_paper_trail class_name: "Renalware::HD::Version"

      validates :patient, presence: true
      validates :hospital_unit, presence: true
      validates :signed_on_by, presence: true

      validates :performed_on, presence: true
      validates :performed_on, timeliness: { type: :date }

      validates :start_time, presence: true
      validates :start_time, timeliness: { type: :time }

      validates :end_time, timeliness: { type: :time, allow_blank: true }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true
    end
  end
end
