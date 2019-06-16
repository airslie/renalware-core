# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class EQ5DPivotedResponse < ApplicationRecord
      scope :ordered, -> { order(answered_on: :desc) }
    end
  end
end
