require_dependency "renalware"

module Renalware
  class MockErrorsController < BaseController

    def index
      0 / 0 # ZeroDivisionError
    end
  end
end
