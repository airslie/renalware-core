require_dependency "renalware/letters"

module Renalware
  module Letters
    class LettersController < Letters::BaseController
      before_filter :load_patient

      def index
        @letters = @patient.letters
      end

      def new
        @letter = @patient.letters.new
      end

      def create
        @letter = @patient.letters.new(letter_params)

        if @letter.save
          redirect_to patient_letters_letters_path(@patient),
            notice: t(".success", model_name: "Letter")
        else
          flash[:error] = t(".failed", model_name: "Letter")
          render :new
        end
      end

      def show
        @letter = @patient.letters.find(params[:id])
      end

      def edit
        @letter = @patient.letters.find(params[:id])
      end

      def update
        @letter = @patient.letters.find(params[:id])
        if @letter.update(letter_params)
          redirect_to patient_letters_letters_path(@patient),
            notice: t(".success", model_name: "Letter")
        else
          flash[:error] = t(".failed", model_name: "Letter")
          render :edit
        end
      end

      private

      def letter_params
        params.require(:letters_letter)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :letterhead_id, :author_id, :description, :issued_on,
          :salutation, :body, :notes
        ]
      end
    end
  end
end