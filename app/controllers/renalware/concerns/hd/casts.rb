# frozen_string_literal: true

require "active_support/concern"

module Renalware
  module Concerns
    module HD
      module Casts
        extend ActiveSupport::Concern

        included do
          def hd_patient
            @hd_patient ||= Renalware::HD.cast_patient(patient)
          end
        end
      end
    end
  end
end
