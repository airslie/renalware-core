require_dependency "renalware/letters"
require "smart_delegator"

module Renalware
  module Letters
    class LettersController < Letters::BaseController
      before_filter :load_patient

      def index
        @letters = CollectionPresenter.new(@patient.letters, LetterPresenter)
      end

      def new
        render_form(LetterFactory.new(@patient).build, :new)
      end

      def create
        DraftLetter.build
          .on(:draft_letter_successful) { redirect_to_letters_list(@patient) }
          .on(:draft_letter_failed) { |letter| render_form(letter, :new) }
          .call(@patient, letter_params)
      end

      def show
        @letter = LetterPresenter.new(@patient.letters.find(params[:id]))
      end

      def edit
        render_form(@patient.letters.find(params[:id]), :edit)
      end

      def update
        ReviseLetter.build
          .on(:revise_letter_successful) { redirect_to_letters_list(@patient) }
          .on(:revise_letter_failed) { |letter| render_form(letter, :edit) }
          .call(@patient, params[:id], letter_params)
      end

      private

      def redirect_to_letters_list(patient)
        redirect_to patient_letters_letters_path(patient),
          notice: t(".success", model_name: "Letter")
      end

      def render_form(letter, action)
        @letter = LetterFormPresenter.new(letter)
        flash[:error] = t(".failed", model_name: "Letter")
        render action
      end

      def letter_params
        params
          .require(:letters_letter)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
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
        [:id, :name, :street_1, :street_2, :city, :county, :postcode, :country, :_destroy]
      end
    end
  end
end