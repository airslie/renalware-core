require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactsController < Letters::BaseController
      before_filter :load_patient

      def index
        render :index, locals: {
          patient: @patient,
          contact: build_contact,
          contacts: find_contacts
        }
      end

      def create
        contact = @patient.assign_contact(contact_params)
        if contact.save
          render :create, locals: { patient: @patient, contact: contact, contacts: find_contacts }
        else
          render :create, locals: { patient: @patient, contact: contact }
        end
      end

      private

      def build_contact
        Contact.new
      end

      def find_contacts
        @patient.contacts
      end

      def contact_params
        params
          .require(:letters_contact)
          .permit(:person_id)
      end
    end
  end
end
