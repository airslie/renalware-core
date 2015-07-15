class LettersController < RenalwareController

  # Cancancan authorization filter
  load_and_authorize_resource

  before_filter :load_patient, except: :author
  before_filter :load_author, only: :author

  def index
    @letters = Letter.where(patient: @patient)
  end

  def author
    @letters = Letter.where(author: @author)
  end

  def new
    @letter = Letter.new(patient: @patient)
  end

  def create
    @letter = Letter.new(letter_params)

    if service.update!(full_params)
      redirect_to patient_letters_path(@patient)
    else
      flash[:error] = 'Failed to save letter'
      render :new
    end
  end

  def update
    @letter = Letter.find(params[:id])

    if service.update!(full_params)
      redirect_to patient_letters_path(@patient)
    else
      flash[:error] = 'Failed to update letter'
      render :edit
    end
  end

  private

  def full_params
    letter_params.merge(other_recipient_address: params[:other_recipient_address])
  end

  def letter_params
    params.require(:letter).permit(:id, :patient_id, :author_id,
                                   :letter_type, :clinic_date,
                                   :recipient,
                                   :letter_description_id,
                                   :body, :state)
  end

  def service
    LetterService.new(@letter)
  end

  def load_author
    @author = User.find(params[:author_id])
  end
end
