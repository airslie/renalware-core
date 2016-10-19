require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactPresenter < DumbDelegator
      def description_name
        if description.unspecified?
          "#{description.to_s} (#{other_description})"
        else
          description.to_s
        end
      end
    end
  end
end
