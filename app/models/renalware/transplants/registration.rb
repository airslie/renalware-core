require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class Registration < ActiveRecord::Base
      include Document::Base
      include PatientScope

      belongs_to :patient
      has_many :statuses, class_name: "RegistrationStatus", foreign_key: "registration_id"

      has_paper_trail class_name: "Renalware::Transplants::RegistrationVersion"
      has_document class_name: "RegistrationDocument"

      accepts_nested_attributes_for :statuses

      def self.policy_class
        BasePolicy
      end

      def current_status
        statuses.find_by(terminated_on: nil)
      end

      # @section services
      #
      def add_status!(params)
        statuses.create!(params)
        recompute_termination_dates!
      end

      def update_status!(status, params)
        status.attributes = params
        if status.changed?
          status.save
          recompute_termination_dates!
        end
      end

      def delete_status!(status)
        status.destroy
        recompute_termination_dates!
      end


      private

      def recompute_termination_dates!
        previous_started_on = nil
        statuses.ordered(:desc).each do |status|
          status.update!(terminated_on: previous_started_on)
          previous_started_on = status.started_on
        end
      end
    end
  end
end