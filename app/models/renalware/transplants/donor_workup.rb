module Renalware
  module Transplants
    class DonorWorkup < ActiveRecord::Base
      include Document::Base

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::DonorWorkupVersion"
      has_document class_name: "DonorWorkupDocument"

      def self.for_patient(patient)
        where(patient: patient).first_or_initialize
      end
    end
  end
end
