module Renalware
  module Transplants
    class RecipientWorkup < ActiveRecord::Base
      include Document::Base

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::RecipientWorkupVersion"
      has_document class_name: "RecipientWorkupDocument"

      def self.for_patient(patient)
        where(patient: patient).first_or_initialize
      end
    end
  end
end
