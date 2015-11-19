require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class Registration < ActiveRecord::Base
      include Document::Base
      include PatientScope

      belongs_to :patient
      has_many :statuses, class_name: "RegistrationStatus", foreign_key: "registration_id"
      has_one :current_status, -> { where(terminated_on: nil) },
        class_name: "RegistrationStatus", foreign_key: "registration_id"


      has_paper_trail class_name: "Renalware::Transplants::RegistrationVersion"
      has_document class_name: "Renalware::Transplants::RegistrationDocument"

      accepts_nested_attributes_for :statuses

      def self.policy_class
        BasePolicy
      end

      # @section services
      #
      def add_status!(params)
        Registration.transaction do
          statuses.create(params).tap do |status|
            recompute_termination_dates! if status.valid?
          end
        end
      end

      def update_status!(status, params)
        Registration.transaction do
          if status.update(params)
            recompute_termination_dates!
          end
          status
        end
      end

      def delete_status!(status)
        Registration.transaction do
          status.destroy
          recompute_termination_dates!
        end
      end


      private

      def recompute_termination_dates!
        previous_started_on = nil
        statuses.ordered(:desc).each do |status|
          status.update_column(:terminated_on, previous_started_on)
          previous_started_on = status.started_on
        end
      end
    end
  end
end
