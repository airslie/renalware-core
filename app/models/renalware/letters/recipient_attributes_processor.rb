require_dependency "renalware/letters"

# This class is responsible for transforming the attributes
# of a recipient.  The resulting attributes can then
# be mass assigned to an ActiveRecord recipient object.
module Renalware
  module Letters
    class RecipientAttributesProcessor
      def initialize(patient, attributes)
        @patient = patient
        @attributes = attributes
      end

      def call
        case person_role
        when "contact"
          put_contact_as_addressee
        else
          clear_addressee
        end
        remove_addressee_id
        @attributes
      end

      private

      def put_contact_as_addressee
        @attributes.merge!(addressee: fetch_contact)
      end

      def remove_addressee_id
        @attributes.except!(:addressee_id)
      end

      def clear_addressee
        @attributes.merge!(addressee: nil)
      end

      def fetch_contact
        @patient.contacts.find_by(id: contact_id)
      end

      def person_role
        @attributes[:person_role]
      end

      def contact_id
        @attributes[:addressee_id]
      end
    end
  end
end