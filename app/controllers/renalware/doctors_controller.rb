module Renalware
  class DoctorsController < BaseController
    include Renalware::Concerns::Pageable

    def index
      @doctors = Doctor.order(:last_name).page(@page).per(@per_page)
      authorize @doctors
    end

    def new
      @doctor = Doctor.new
      authorize @doctor
    end

    def edit
      @doctor = Doctor.find(params[:id])
      authorize @doctor
    end

    def create
      if service.update!(doctor_params)
        redirect_to doctors_path
      else
        flash[:error] = "Failed to create new Doctor"
        render :new
      end
    end

    def update
      if service.update!(doctor_params)
        redirect_to doctors_path
      else
        flash[:error] = "Failed to update Doctor"
        render :edit
      end
    end

    def destroy
      authorize Doctor.destroy(params[:id])

      redirect_to doctors_path, notice: "Doctor successfully deleted"
    end
    private

    def service
      @doctor = Doctor.find_or_initialize_by(id: params[:id])
      authorize @doctor

      DoctorService.new(@doctor)
    end

    def doctor_params
      params.require(:doctor).permit(
        :first_name, :last_name, :email, :practitioner_type, :code, practice_ids: [],
        address_attributes: [
          :id, :street_1, :street_2, :city, :county, :postcode, :country
        ]
      )
    end
  end
end
