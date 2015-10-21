require "document/base"

module Renalware
  module Transplants
    class Registration < ActiveRecord::Base
      include Document::Base
      include PatientScope

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::RegistrationVersion"
      has_document class_name: "RegistrationDocument"

      def self.policy_class
        BasePolicy
      end
    end
  end
end