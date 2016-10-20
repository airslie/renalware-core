require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactPresenter < DumbDelegator
      def description_name
        description.unspecified? ?  other_description : description.to_s
      end
    end
  end
end
