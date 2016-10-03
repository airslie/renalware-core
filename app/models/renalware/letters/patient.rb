require_dependency "renalware/letters"

module Renalware
  module Letters
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :letters
      has_many :contacts
      belongs_to :primary_care_physician, class_name: "Renalware::Letters::PrimaryCarePhysician"

      def cc_on_letter?(letter)
        return false unless letter.subject?(self)
        return false unless cc_on_all_letters?

        !letter.main_recipient.patient?
      end

      def assign_contact(person)
        contacts.build(person: person)
      end

      def available_contact?(person)
        contacts.map(&:person).include?(person)
      end
    end
  end
end
