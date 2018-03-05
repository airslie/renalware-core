# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRulePresenter < SimpleDelegator
        def self.present(rules)
          rules.map { |rule| new rule }
        end
      end
    end
  end
end
