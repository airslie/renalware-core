module Renalware
  class ProblemsController < BaseController
    before_action :load_patient, only: :index

    def index
      @patient.problems.build
    end
  end
end
