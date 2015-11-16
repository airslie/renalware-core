require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class Donation < ActiveRecord::Base
      include PatientScope

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::Version"

      validates :status, presence: true

      def self.policy_class
        BasePolicy
      end
    end
  end
end