require_dependency "renalware/transplants"
require "document/base"
require "age_computation"

module Renalware
  module Transplants
    class RecipientOperation < ActiveRecord::Base
      include Document::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient

      before_validation :compute_donor_age

      scope :ordered, -> { order(performed_on: :asc) }
      scope :reversed, -> { order(performed_on: :desc) }

      has_paper_trail class_name: "Renalware::Transplants::RecipientOperationVersion"
      has_document class_name: "Renalware::Transplants::RecipientOperationDocument"

      validates :performed_on, presence: true
      validates :theatre_case_start_time, presence: true
      validates :donor_kidney_removed_from_ice_at, presence: true
      validates :kidney_perfused_with_blood_at, presence: true
      validates :operation_type, presence: true
      validates :transplant_site, presence: true
      validates :cold_ischaemic_time, presence: true
      validates :warm_ischaemic_time, presence: true

      validates :donor_kidney_removed_from_ice_at, timeliness: { type: :datetime }
      validates :kidney_perfused_with_blood_at, timeliness: { type: :datetime }
      validates :theatre_case_start_time, timeliness: { type: :time }
      validates :cold_ischaemic_time, timeliness: { type: :time }
      validates :warm_ischaemic_time, timeliness: { type: :time }

      enumerize :operation_type, in: %i(kidney kidney_pancreas pancreas kidney_liver liver)

      def theatre_case_start_time
        TimeOfDay.new(read_attribute(:theatre_case_start_time))
      end

      def cold_ischaemic_time
        # For presentation purposes
        TimeOfDay.new(read_attribute(:cold_ischaemic_time))
      end

      def warm_ischaemic_time
        # For presentation purposes
        TimeOfDay.new(read_attribute(:warm_ischaemic_time))
      end

      def recipient_age_at_operation
        @recipient_age_at_operation ||= Age.new.tap do |age|
          age.set_from_dates(patient.born_on, performed_on)
        end
      end

      private

      def compute_donor_age
        document.donor.age.set_from_dates(document.donor.born_on, performed_on)
      end
    end
  end
end
