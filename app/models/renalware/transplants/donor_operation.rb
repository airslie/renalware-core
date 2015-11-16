require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class DonorOperation < ActiveRecord::Base
      include Document::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient

      scope :ordered, -> (direction=:desc) { order(performed_on: direction) }

      has_paper_trail class_name: "Renalware::Transplants::DonorOperationVersion"
      has_document class_name: "DonorOperationDocument"

      validates :performed_on, presence: true

      def self.policy_class
        BasePolicy
      end
    end
  end
end