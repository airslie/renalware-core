require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class Profile < ActiveRecord::Base
      include Document::Base
      include PatientScope
      include HasSchedule
      include Accountable

      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :prescriber, class_name: "User", foreign_key: "prescriber_id"
      belongs_to :named_nurse, class_name: "User", foreign_key: "named_nurse_id"
      belongs_to :transport_decider, class_name: "User", foreign_key: "transport_decider_id"

      has_document class_name: "Renalware::HD::ProfileDocument"
      has_paper_trail class_name: "Renalware::HD::Version"

      validates :patient, presence: true
      validates :prescriber, presence: true

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true
    end
  end
end
