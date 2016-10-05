require_dependency "renalware/letters"

# This class is responsible for transforming the attributes
# of a recipient.  The resulting attributes can then
# be mass assigned to an ActiveRecord recipient object.
module Renalware
  module Letters
    class RecipientParamsProcessor
      def initialize(patient)
        @patient = patient
      end

      def call(params)
        if can_have_contact_as_addressee?(params)
          params = put_contact_as_addressee(params)
        else
          params = clear_addressee(params)
        end
        params = remove_addressee_id(params)

        params
      end

      private

      def can_have_contact_as_addressee?(params)
        params[:person_role] == "contact"
      end

      def put_contact_as_addressee(params)
        params.merge(addressee: fetch_contact(params))
      end

      def remove_addressee_id(params)
        params.except(:addressee_id)
      end

      def clear_addressee(params)
        params.merge(addressee: nil)
      end

      def fetch_contact(params)
        @patient.contacts.find_by(id: params[:addressee_id])
      end
    end
  end
end