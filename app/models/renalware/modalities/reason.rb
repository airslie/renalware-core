# frozen_string_literal: true

require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Reason < ApplicationRecord
      def self.policy_class
        BasePolicy
      end
    end
  end
end
