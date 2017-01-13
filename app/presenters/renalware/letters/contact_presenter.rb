require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactPresenter < DumbDelegator
      def description_name
        description.unspecified? ? other_description : description.to_s
      end

      def name_and_description
        "#{self} (#{description_name})"
      end

      def salutation
        return unless person
        if person.title.present?
          [person.title, person.family_name]
        else
          [person.given_name, person.family_name]
        end.compact.join(" ")
      end
    end
  end
end
