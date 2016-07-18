module Renalware
  module Letters
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = Renalware::Letters.cast_patient(@patient)
      end
    end
  end
end
