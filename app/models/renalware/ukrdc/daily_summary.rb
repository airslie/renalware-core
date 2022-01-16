# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class DailySummary < ApplicationRecord
      # backed by a SQL view
    end
  end
end
