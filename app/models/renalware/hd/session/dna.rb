module Renalware
  module HD
    class Session::DNA < Session
      def self.policy_class
        DNASessionPolicy
      end
    end
  end
end
