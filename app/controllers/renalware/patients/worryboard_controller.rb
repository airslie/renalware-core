require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryboardController < BaseController
      include Renalware::Concerns::Pageable

      def show
        authorize Worry, :index?
        render locals: { worries: Worry.all.order(created_at: :asc).page(page).per(per_page) }
      end
    end
  end
end
