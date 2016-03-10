require_dependency "renalware/letters"

module Renalware
  module Letters
    class LettersController < BaseController

      before_filter :load_patient, except: :author
      # before_filter :load_author, only: :author

      def index
        @letters = @patient.letters
      end

      # def author
      #   @letters = BaseLetter.where(author: @author)
      #   authorize @letters
      # end

      def new
        @letter = @patient.letters.new(patient: @patient)
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
        @letter = BaseLetter.find(params[:id])
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

      # Provides the underlying STI class
      # def letter_class
      #   klass = params[:letter_type] || 'Letter'
      #   "Renalware::Letters::#{klass}".constantize if klass.in?(LetterType.all)
      # end

      # def full_params
      #   letter_params.merge(other_recipient_address: params[:other_recipient_address])
      # end

      def letter_params
        params.require(:letters_letter)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :author_id, :description, :issued_on,
          :salutation, :body, :notes
        ]
      end
      # def service
      #   LetterService.new(@letter)
      # end

      # def load_author
      #   @author = User.find(params[:author_id])
      # end
    end
  end
end