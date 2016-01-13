module Renalware
  class LettersController < BaseController

    before_filter :load_patient, except: :author
    before_filter :load_author, only: :author

    def index
      @letters = @patient.letters
    end

    def author
      @letters = BaseLetter.where(author: @author)
      authorize @letters
    end

    def new
      @letter = letter_class.new(patient: @patient)
    end

    def create
      @letter = letter_class.new(letter_params)
      @letter.patient = @patient

      if service.update!(full_params)
        redirect_to patient_letters_path(@patient),
          notice: t(".success", model_name: "letter")
      else
        flash[:error] = t(".failed", model_name: "letter")
        render :new
      end
    end

    def show
      @letter = BaseLetter.find(params[:id])
    end

    def edit
      @letter = letter_class.find(params[:id])
      authorize @letter
    end

    def update
      @letter = letter_class.find(params[:id])
      authorize @letter
      if service.update!(full_params)
        redirect_to patient_letters_path(@patient),
          notice: t(".success", model_name: "letter")
      else
        flash[:error] = t(".failed", model_name: "letter")
        render :edit
      end
    end

    private

    # Provides the underlying STI class
    def letter_class
      klass = params[:letter_type] || 'Letter'
      "Renalware::#{klass}".constantize if klass.in?(LetterType.all)
    end

    def full_params
      letter_params.merge(other_recipient_address: params[:other_recipient_address])
    end

    def letter_params
      params.require(:letter).permit(
        :id, :author_id, :clinic_visit_id, :recipient, :letter_description_id,
        :body, :state
      )
    end

    def service
      LetterService.new(@letter)
    end

    def load_author
      @author = User.find(params[:author_id])
    end
  end
end
