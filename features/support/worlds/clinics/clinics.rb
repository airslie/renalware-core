# frozen_string_literal: true

module World
  module Clinics
    module Clinics
      module Domain
        # @section commands

        def create_clinic(params)
          Renalware::Clinics::Clinic.create(params)
        end
      end

      module Web
        include Domain
      end
    end
  end
end
