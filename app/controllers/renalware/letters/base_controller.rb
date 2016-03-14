module Renalware
  module Letters
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = ActiveType.cast(@patient, Renalware::Letters::Patient)
      end
    end
  end
end
