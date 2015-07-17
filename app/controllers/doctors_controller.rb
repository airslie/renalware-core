class DoctorsController < RenalwareController
  include Pageable

  def index
    @doctors = Doctor.order(:last_name).page(@page).per(@per_page)
  end

  def new
    @doctor = Doctor.new
  end

  def edit
    @doctor = Doctor.find(params[:id])
  end

  def create
    if service.update!(doctor_params)
      redirect_to doctors_path
    else
      render :new, alert: 'Failed to create new Doctor'
    end
  end

  def update
    if service.update!(doctor_params)
      redirect_to doctors_path
    else
      render :edit, alert: 'Failed to update Doctor'
    end
  end

  def destroy
    if Doctor.destroy(params[:id])
      redirect_to doctors_path, notice: 'Doctor successfully deleted'
    else
      render :index, alert: 'Failed to delete Doctor'
    end
  end

  private

  def service
    @doctor = Doctor.find_or_initialize_by(id: params[:id])
    DoctorService.new(@doctor)
  end

  def doctor_params
    params.require(:doctor).permit(
      :first_name, :last_name, :email, :practitioner_type, :code, practice_ids: [],
      address_attributes: [:id, :street_1, :street_2, :city, :county, :postcode, :country])
  end
end
