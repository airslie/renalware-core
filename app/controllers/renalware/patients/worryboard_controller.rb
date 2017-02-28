require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryboardController < BaseController
      def show
        authorize Worry, :index?
        render locals: { worries: Worry.all.page(params[:page]) }
      end
    end
  end
end
