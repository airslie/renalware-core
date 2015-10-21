require "document/base"

module Renalware
  module Transplants
    class DonorWorkup < ActiveRecord::Base
      include Document::Base
      include PatientScope

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::DonorWorkupVersion"
      has_document class_name: "DonorWorkupDocument"

      def self.policy_class
        BasePolicy
      end
    end
  end
end
