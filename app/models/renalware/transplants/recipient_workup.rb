module Renalware
  module Transplants
    class RecipientWorkup < ActiveRecord::Base
      self.table_name = 'transplants_recipient_workups'

      include Document::Embedded

      belongs_to :patient

      validates_presence_of :performed_at

      def self.for_patient(patient)
        where(patient: patient)
      end
    end
  end
end