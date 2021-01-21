# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactsController < Letters::BaseController
      def index
        authorize patient
        render :index, locals: {
          patient: patient,
          contact: build_contact,
          contact_descriptions: find_contact_descriptions,
          contacts: find_contacts
        }
      end

      def create
        authorize patient
        contact = patient.assign_contact(contact_params)
        if contact.save
          create_contact_successful(contact)
        else
          create_contact_failed(contact)
        end
      end

      def edit
        authorize patient
        contact = patient.contacts.find(params[:id])
        render_edit(contact)
      end

      def update
        authorize patient
        contact = patient.contacts.find(params[:id])
        if contact.update(update_contact_params)
          flash.now[:notice] = success_msg_for("contact")
          render locals: { patient: patient, contact: ContactPresenter.new(contact) }
        else
          render_edit(contact)
        end
      end

      private

      def render_edit(contact)
        render :edit, locals: {
          patient: patient,
          contact: contact,
          contact_descriptions: find_contact_descriptions
        }, layout: false
      end

      def build_contact
        Contact.new.tap(&:build_person)
      end

      def create_contact_successful(contact)
        render json: contact, status: :created
      end

      def create_contact_failed(contact)
        render json: contact.errors.full_messages, status: :bad_request
      end

      def find_contacts
        CollectionPresenter.new(
          patient.contacts.includes(:description, person: { address: :country }).ordered,
          ContactPresenter
        )
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

      def update_contact_params
        params
          .require(:letters_contact)
          .permit(:default_cc, :description_id, :other_description, :notes)
      end

      def contact_attributes
        [
          :person_id, :default_cc, :description_id, :other_description,
          :notes, person_attributes: person_attributes
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
          :id, :name, :organisation_name, :street_1, :street_2, :street_3, :town, :county,
          :postcode, :country_id, :telephone, :email
        ]
      end

      # Person requires the user who created the record. This is only needed
      # if we are creating the person for the contact at the same time.
      #
      def try_merge_person_creator(params)
        return params if params[:person_attributes].blank?

        params[:person_attributes][:by] = current_user
        params
      end
    end
  end
end
