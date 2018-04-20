# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    module Delivery
      class PatientHasNoPracticeError < StandardError; end
    end
  end
end
