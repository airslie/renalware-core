# frozen_string_literal: true

require_dependency "renalware/surveys"

module Renalware
  module Surveys
    class EQ5DPivotedResponse < ApplicationRecord
      scope :ordered, -> { order(answered_on: :desc) }
    end
  end
end
