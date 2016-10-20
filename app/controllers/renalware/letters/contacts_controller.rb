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
        CollectionPresenter.new(@patient.contacts.ordered, ContactPresenter)
      end

      def find_contact_descriptions
        CollectionPresenter.new(ContactDescription.ordered, ContactDescriptionPresenter)
      end

      def contact_params
        params
          .require(:letters_contact)
          .permit(contact_attributes)
          .tap { |p| try_merge_person_creator(p) }
      end

      def contact_attributes
        [
          :person_id, :default_cc, :description_id, :other_description,
          person_attributes: person_attributes
        ]
      end

      def person_attributes
        [
          :given_name, :family_name, :title,
          address_attributes: person_address_attributes
        ]
      end

      def person_address_attributes
        [
          :id, :name, :organisation_name, :street_1, :street_2, :city, :county,
          :postcode, :country
        ]
      end

      # Person requires the user who created the record. This is only needed
      # if we are creating the person for the contact at the same time.
      #
      def try_merge_person_creator(params)
        return params unless params[:person_attributes].present?

        params[:person_attributes].merge!(by: current_user)
        params
      end
    end
  end
end
