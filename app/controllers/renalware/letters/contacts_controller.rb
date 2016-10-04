require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactsController < Letters::BaseController
      before_filter :load_patient

      def index
        contacts = find_contacts

        render :index, locals: {
          patient: @patient,
          contacts: contacts
        }
      end

      def create
        create_contact

        redirect_to patient_letters_contacts_url(@patient),
          notice: t(".success", model_name: "contact")
      end

      private

      def find_contacts
        @patient.contacts
      end

      def create_contact
        @patient
          .assign_contact(contact_params)
          .save!
      end

      def contact_params
        params
          .require(:letters_contact)
          .permit(:person_id)
      end
    end
  end
end
