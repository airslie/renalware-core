# frozen_string_literal: true

module Renalware
  module HD
    class SlotRequestPolicy < BasePolicy
      def historical? = user_is_any_admin?
    end
  end
end
