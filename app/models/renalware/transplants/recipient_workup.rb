require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientWorkup < ActiveRecord::Base
      include Document::Base
      include PatientScope

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::RecipientWorkupVersion"
      has_document class_name: "Renalware::Transplants::RecipientWorkupDocument"

      def self.policy_class
        BasePolicy
      end
    end
  end
end
