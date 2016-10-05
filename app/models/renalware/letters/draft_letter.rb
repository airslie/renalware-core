require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      include Wisper::Publisher

      def self.build
        self.new
      end

      def call(patient, params={})
        letter = LetterFactory.new(patient).build(params)
        Letter.transaction do
          letter.save!
          hack_people!(letter)
        end
        letter.reload
        broadcast(:draft_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:draft_letter_failed, letter)
      end

      private

      # Will go away when we add the contact picker in the forms
      def hack_people!(letter)
        letter.cc_recipients.each do |recipient|
          if recipient.contact?
            person = Directory::Person.create!(
              given_name: "John",
              family_name: "II #{recipient.address.name}",
              by: letter.created_by
            )
            person.build_address
            person.address.copy_from(recipient.address)
            person.address.save!

            contact = Contact.create(person: person, patient: letter.patient)

            recipient.addressee = contact
            recipient.save!
          end
        end
      end
    end
  end
end

