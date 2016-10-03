require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactsController < Letters::BaseController
      before_filter :load_patient

      def index
        contacts = find_contacts
        render :index, locals: { contacts: contacts }
      end

      def new
        contact = build_contact
        render_form(contact, :new)
      end

      def create
        create_contact

        redirect_to patient_letters_contacts_url(@patient)
      end

      private

      def find_contacts
        @patient.contacts
      end

      def build_contact
        @patient.contacts.build
      end

      def create_contact
        @patient
          .assign_contact(contact_params)
          .save!
      end

      def render_form(contact, action)
        render action, locals: { contact: contact, people: find_people }
      end

      def find_people
        Directory::Person.all.ordered
      end

      def contact_params
        params
          .require(:letters_contact)
          .permit(:person_id)
      end
    end
  end
end
