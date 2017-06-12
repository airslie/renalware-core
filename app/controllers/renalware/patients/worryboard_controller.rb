require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryboardController < BaseController
      include Renalware::Concerns::Pageable

      def show
        authorize Worry, :index?
        render locals: { worries: Worry.all.page(page).per(per_page) }
      end
    end
  end
end
