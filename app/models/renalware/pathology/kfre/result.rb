# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module KFRE
      class Result
        rattr_initialize [:yr2!, :yr5!]
      end
    end
  end
end
