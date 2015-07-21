class LettersController < RenalwareController

  before_filter :load_patient, except: :author
  before_filter :load_author, only: :author

  def index
    @letters = Letter.where(patient: @patient)
  end

  def author
    @letters = Letter.where(author: @author)
  end

  def new
    @letter = letter_class.new(patient: @patient)
  end

  def create
    @letter = letter_class.new(letter_params)

    if service.update!(full_params)
      redirect_to patient_letters_path(@patient)
    else
      flash[:error] = 'Failed to save letter'
      render :new
    end
  end

  def update
    @letter = letter_class.find(params[:id])

    if service.update!(full_params)
      redirect_to patient_letters_path(@patient)
    else
      flash[:error] = 'Failed to update letter'
      render :edit
    end
  end

  private

  # Provides the underlying STI class
  def letter_class
    klass = params[:type] || 'Letter'
    klass.constantize if klass.in?(LetterType.all)
  end

  def full_params
    letter_params.merge(other_recipient_address: params[:other_recipient_address])
  end

  def letter_params
    params.require(:letter).permit(:id, :patient_id, :author_id,
                                   :type, :clinic_visit_id, :recipient,
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
