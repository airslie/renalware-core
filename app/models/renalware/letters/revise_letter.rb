require_dependency "renalware/letters"

module Renalware
  module Letters
    class ReviseLetter
      include Wisper::Publisher

      def self.build
        self.new
      end

      def call(patient, letter_id, params={})
        letter = patient.letters.pending.find(letter_id)
        Letter.transaction do
          letter.revise(params)
          letter.save!
          hack_people!(letter)
        end
        broadcast(:revise_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:revise_letter_failed, letter)
      end

      private

      # Will go away when we add the contact picker in the forms
      def hack_people!(letter)
        letter.recipients.each do |recipient|
          if recipient.contact?
            if recipient.addressee.blank?
              person = Directory::Person.create!(
                given_name: "John",
                family_name: "II #{recipient.address.name}",
                by: letter.created_by
              )
              person.build_address
              person.address.copy_from(recipient.address)
              person.address.save!

              recipient.addressee = person
              recipient.save!
            else
              recipient.addressee.address.copy_from(recipient.address)
              recipient.addressee.address.save!
            end
          end
        end
      end
    end
  end
end
