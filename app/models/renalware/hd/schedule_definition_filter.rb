# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class ScheduleDefinitionFilter < ApplicationRecord
      # Backed by a Postgres View
    end
  end
end
