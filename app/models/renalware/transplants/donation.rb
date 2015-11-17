require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class Donation < ActiveRecord::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::Version"

      scope :ordered, -> (direction=:desc) { order(created_at: direction) }

      validates :status, presence: true

      enumerize :status, in: %i(pending_workup working_up paired unsuitable)

      def self.policy_class
        BasePolicy
      end
    end
  end
end