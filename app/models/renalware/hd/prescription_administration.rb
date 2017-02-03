require_dependency "renalware/hd"

module Renalware
  module HD
    class PrescriptionAdministration < ApplicationRecord
      include Accountable

      # Set to true by the parent hd_session if we are not signing off at this stage
      attr_accessor :skip_validation

      belongs_to :hd_session, class_name: "HD::Session"
      belongs_to :prescription, class_name: "Medications::Prescription"
      validates :administered, inclusion: { in: [true, false] }, unless: :skip_validation
      validates :prescription, presence: true
    end
  end
end
