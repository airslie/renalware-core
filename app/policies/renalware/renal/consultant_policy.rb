# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Renal
    class ConsultantPolicy < BasePolicy
      def index?
        user_is_super_admin?
      end
      alias show? index?
      alias update? index?
      alias new? index?

      def edit?
        return false unless record.persisted?
        return false if record.deleted?

        user_is_super_admin?
      end
      alias destroy? edit?
    end
  end
end
