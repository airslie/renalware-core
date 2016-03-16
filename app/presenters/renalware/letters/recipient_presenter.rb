require_dependency "renalware/medications"

module Renalware
  module Letters
    class RecipientPresenter < DumbDelegator
      def to_s
        source.present? ? source.full_name : name
      end
    end
  end
end
