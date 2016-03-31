require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestDescription < ActiveRecord::Base
      def to_s
        code
      end
    end
  end
end
