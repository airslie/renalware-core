require_dependency "renalware/directory"

module Renalware
  module Directory
    class PersonAutoCompletePresenter < DumbDelegator
      def to_hash
        { id: id, label: to_s }
      end
    end
  end
end
