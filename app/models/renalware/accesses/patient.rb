require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :profiles
      has_many :procedures
      has_many :assessments

      def current_profile
        profiles.current.first
      end
    end
  end
end
