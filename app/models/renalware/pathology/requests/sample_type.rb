# frozen_string_literal: true

require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      # This is a sample lookup table of sample type values to use in a dropdown
      # when creating a new new rule.
      class SampleType < ApplicationRecord
        validates :name, presence: true
        validates :code, presence: true

        scope :ordered, -> { order(code: :asc) }
      end
    end
  end
end
