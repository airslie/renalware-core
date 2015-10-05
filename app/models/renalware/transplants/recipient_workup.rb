module Renalware
  module Transplants
    class RecipientWorkup < ActiveRecord::Base
      self.table_name = "transplants_recipient_workups"

      include Document::Embedded

      has_paper_trail class_name: "Renalware::Transplants::RecipientWorkupVersion"

      belongs_to :patient

      def self.for_patient(patient)
        where(patient: patient).first_or_initialize
      end
    end
  end
end
