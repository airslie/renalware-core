require_dependency "renalware/transplants"
require "document/base"
require "renalware/automatic_age_calculator"

module Renalware
  module Transplants
    class RecipientOperation < ActiveRecord::Base
      include Document::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient
      has_one :followup, class_name: "RecipientFollowup", foreign_key: "operation_id"

      before_validation :compute_donor_age

      scope :ordered, -> { order(performed_on: :asc) }
      scope :reversed, -> { order(performed_on: :desc) }

      has_paper_trail class_name: "Renalware::Transplants::RecipientOperationVersion"
      has_document class_name: "Renalware::Transplants::RecipientOperationDocument"

      attr_accessor :cold_ischaemic_time_formatted
      attr_accessor :warm_ischaemic_time_formatted

      validates :performed_on, presence: true
      validates :theatre_case_start_time, presence: true
      validates :donor_kidney_removed_from_ice_at, presence: true
      validates :kidney_perfused_with_blood_at, presence: true
      validates :operation_type, presence: true
      validates :transplant_site, presence: true
      validates :cold_ischaemic_time_formatted, presence: true
      validates :warm_ischaemic_time_formatted, presence: true

      validates :donor_kidney_removed_from_ice_at, timeliness: { type: :datetime }
      validates :kidney_perfused_with_blood_at, timeliness: { type: :datetime }
      validates :theatre_case_start_time, timeliness: { type: :time }
      # validates :cold_ischaemic_time, timeliness: { type: :time }
      # validates :warm_ischaemic_time, timeliness: { type: :time }

      enumerize :operation_type, in: %i(kidney kidney_pancreas pancreas kidney_liver liver)

      def theatre_case_start_time
        TimeOfDay.new(read_attribute(:theatre_case_start_time))
      end

      def cold_ischaemic_time_formatted
        # For presentation purposes
        Duration.new(read_attribute(:cold_ischaemic_time)).to_s
      end

      def cold_ischaemic_time_formatted=(value)
        self.cold_ischaemic_time = Duration.from_string(value).seconds
      end

      def warm_ischaemic_time_formatted
        # For presentation purposes
        Duration.new(read_attribute(:warm_ischaemic_time)).to_s
      end

      def warm_ischaemic_time_formatted=(value)
        self.warm_ischaemic_time = Duration.from_string(value).seconds
      end

      def recipient_age_at_operation
        @recipient_age_at_operation ||=
          AutomaticAgeCalculator.new(
            Age.new,
            born_on: patient.born_on, age_on_date: performed_on
          ).compute
      end

      private

      def compute_donor_age
        document.donor.age = AutomaticAgeCalculator.new(
          document.donor.age,
          born_on: document.donor.born_on, age_on_date: performed_on
        ).compute
      end
    end
  end
end
