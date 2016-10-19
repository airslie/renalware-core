require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactsController < Letters::BaseController
      before_filter :load_patient

      def index
        render :index, locals: {
          patient: @patient,
          contact: build_contact,
          contact_descriptions: find_contact_descriptions,
          contacts: find_contacts
        }
      end

      def create
        contact = @patient.assign_contact(contact_params)
        if contact.save
          create_contact_successful(contact)
        else
          create_contact_failed(contact)
        end
      end

      private

      def build_contact
        Contact.new
      end

      def create_contact_successful(contact)
        render json: contact, status: :created
      end

      def create_contact_failed(contact)
        render json: contact.errors.full_messages, status: :bad_request
      end

      def find_contacts
        @patient.contacts.ordered
      end

      def find_contact_descriptions
        ContactDescription.ordered
      end

      def contact_params
        params
          .require(:letters_contact)
          .permit(:person_id, :default_cc)
      end
    end
  end
end
