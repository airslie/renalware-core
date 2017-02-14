require_dependency "renalware/letters"

module Renalware
  module Letters
    class LettersController < Letters::BaseController
      before_action :load_patient, except: [:new, :author]

      def index
        render :index, locals: { letters: present_letters(find_letters) }
      end

      def author
        user = Renalware::User.find(params[:author_id])
        @author = Letters.cast_author(user)
        @letters = @author.letters
        authorize @letters
      end

      def new
        @patient = load_and_authorize_patient
        letter = LetterFactory
          .new(@patient,
               event: find_event,
               author: current_user,
               clinical: clinical?)
          .with_contacts_as_default_ccs
          .build
        RememberedLetterPreferences.new(session).apply_to(letter)
        render_form(letter, :new)
      end

      def create
        attributes = letter_params.merge(event: find_event)
        DraftLetter.build
          .subscribe(self)
          .call(@patient, attributes)
      end

      def draft_letter_successful(letter)
        RememberedLetterPreferences.new(session).persist(letter)
        redirect_to_letter_show(@patient, letter)
      end

      def draft_letter_failed(letter)
        flash[:error] = t(".failed", model_name: "Letter")
        render_form(letter, :new)
      end

      def show
        @letter = present_letter(find_letter(params[:id]))
      end

      def edit
        render_form(find_letter(params[:id]), :edit)
      end

      def update
        ReviseLetter.build
          .subscribe(self)
          .call(@patient, params[:id], letter_params)
      end

      def revise_letter_successful(letter)
        redirect_to_letter_show(@patient, letter)
      end

      def revise_letter_failed(letter)
        flash[:error] = t(".failed", model_name: "Letter")
        render_form(letter, :edit)
      end

      def contact_added
        contact = @patient.contacts.find(params[:id])
        @contact = ContactPresenter.new(contact)
        @letter = LetterFormPresenter.new(Letter.new)
      end

      private

      def load_and_authorize_patient
        patient = Patient.includes(:prescriptions).find(params[:patient_id])
        authorize patient
        patient
      end

      def find_letters
        @patient.letters
          .with_main_recipient
          .with_letterhead
          .with_author
          .with_event
          .with_patient
      end

      def find_letter(id)
        @patient.letters.find(id)
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, LetterPresenterFactory)
      end

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      def redirect_to_letter_show(patient, letter)
        redirect_to patient_letters_letter_path(patient, letter)
      end

      def clinical?
        params[:clinical].present?
      end

      def render_form(letter, action)
        letter = LetterFormPresenter.new(letter)
        contacts = find_contacts
        contact = build_contact
        render action, locals: {
          patient: @patient, letter: letter, contact: contact,
            contacts: contacts, contact_descriptions: find_contact_descriptions
        }
      end

      def find_event
        return unless event_type.present?
        event_class.for_patient(@patient).find(event_id)
      end

      def find_contact_descriptions
        CollectionPresenter.new(ContactDescription.ordered, ContactDescriptionPresenter)
      end

      def find_contacts
        ContactsPresenter.new(@patient.contacts.with_description.ordered, ContactPresenter)
      end

      def build_contact
        Contact.new.tap(&:build_person)
      end

      def event_class
        @event_class ||= event_type.singularize.classify.constantize
      end

      def event_type
        params.fetch(:event_type, nil)
      end

      def event_id
        params.fetch(:event_id, nil)
      end

      def letter_params
        params
          .require(:letter)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :event_type, :event_id, :clinical,
          :letterhead_id, :author_id, :description, :issued_on,
          :salutation, :body, :notes,
          main_recipient_attributes: main_recipient_attributes,
          cc_recipients_attributes: cc_recipients_attributes
        ]
      end

      def main_recipient_attributes
        [
          :id, :person_role, :addressee_id
        ]
      end

      def cc_recipients_attributes
        [
          :id, :person_role, :addressee_id, :_keep
        ]
      end

      def address_attributes
        [
          :id, :name, :organisation_name, :street_1, :street_2, :city, :county,
          :postcode, :country, :_destroy
        ]
      end
    end
  end
end
