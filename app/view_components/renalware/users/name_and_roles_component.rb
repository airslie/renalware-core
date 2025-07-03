module Renalware
  module Users
    # Renders a section on the dashboard that displays the users's full name and roles.
    # This is a MESH API recommendation.
    class NameAndRolesComponent < ApplicationComponent
      pattr_initialize [:current_user!]
      delegate :full_name, to: :current_user

      def role_names
        Array(current_user.role_names).map(&:titleize).join(", ")
      end
    end
  end
end
