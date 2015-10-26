module Renalware
  class MedicationsController < BaseController
    before_action :load_patient, only: :index

    def index
      render
    end
  end
end
