require_dependency "renalware/medications"

module Renalware
  module Letters
    class RecipientPresenter < DumbDelegator
      def to_s
        if source
          source.full_name
        else
          name
        end
      end
    end
  end
end
