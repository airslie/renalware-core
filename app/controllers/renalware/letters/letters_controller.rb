require_dependency "renalware/letters"

module Renalware
  module Letters
    class LettersController < Letters::BaseController
      before_filter :load_patient

      def index
        render :index, locals: { letters: present_letters(@patient.letters) }
      end

      def new
        letter = LetterFactory.new(@patient).build(event: find_event)
        render_form(letter, :new)
      end

      def create
        attributes = letter_params.merge(event: find_event)
        DraftLetter.build
          .subscribe(self)
          .call(@patient, attributes)
      end

      def draft_letter_successful(letter)
        redirect_to_letter_show(@patient, letter)
      end

      def draft_letter_failed(letter)
        flash[:error] = t(".failed", model_name: "Letter")
        render_form(letter, :new)
      end

      def show
        @letter = present_letter(@patient.letters.find(params[:id]))
      end

      def edit
        render_form(@patient.draft_letters.find(params[:id]), :edit)
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

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, LetterPresenterFactory)
      end

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      def redirect_to_letter_show(patient, letter)
        redirect_to patient_letters_letter_path(patient, letter)
      end

      def render_form(letter, action)
        @letter = LetterFormPresenter.new(letter)
        render action
      end

      def find_event
        return unless event_type.present?
        event_class.for_patient(@patient).find(event_id)
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
          .require(:letters_letter_draft)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :event_type, :event_id,
          :letterhead_id, :author_id, :description, :issued_on,
          :salutation, :body, :notes,
          main_recipient_attributes: main_recipient_attributes,
          cc_recipients_attributes: cc_recipients_attributes
        ]
      end

      def main_recipient_attributes
        [
          :id, :person_role,
          address_attributes: address_attributes
        ]
      end

      def cc_recipients_attributes
        [
          :id, :person_role, :_destroy,
          address_attributes: address_attributes
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
