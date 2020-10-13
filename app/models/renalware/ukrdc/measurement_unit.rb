# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    # Represents a valid UKRDC pathology test result measurement unit e.g. "mg".
    # See https://github.com/renalreg/ukrdc/blob/master/Schema/Types/CF_RR23.xsd
    class MeasurementUnit < ApplicationRecord
      validates :name, presence: true
    end
  end
end
