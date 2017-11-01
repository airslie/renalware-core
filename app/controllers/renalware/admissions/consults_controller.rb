require "renalware/admissions"

module Renalware
  module Admissions
    class ConsultsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        consults = Consult.all
        authorize consults
        render locals: { consults: consults }
      end
    end
  end
end
