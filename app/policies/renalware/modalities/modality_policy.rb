# frozen_string_literal: true

module Renalware
  module Modalities
    class ModalityPolicy < BasePolicy
      def edit? = user_is_any_admin?
      def update? = user_is_any_admin?
    end
  end
end
