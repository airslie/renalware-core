require_dependency "renalware/patients"

module Renalware
  module Patients
    class BookmarkPolicy < BasePolicy
      def destroy?
        record.user == Patients.cast_user(user)
      end
    end
  end
end
