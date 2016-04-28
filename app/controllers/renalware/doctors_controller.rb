module Renalware
  class DoctorsController < BaseController
    include Renalware::Concerns::Pageable

    before_action :find_doctor, only: [:edit, :update]

    def index
      @doctors = Doctor.order(:family_name).page(@page).per(@per_page)
      authorize @doctors
    end

    def new
      @doctor = Doctor.new
      authorize @doctor
    end

    def edit
      render_form(@doctor, :edit)
    end

    def create
      @doctor = Doctor.new(doctor_params)
      authorize @doctor

      if @doctor.save
        redirect_to doctors_path,
          notice: t(".success", model_name: "doctor")
      else
        flash[:error] = t(".failed", model_name: "doctor")
        render :new
      end
    end

    def update
      Doctors::UpdateDoctor.build
        .on(:update_doctor_successful) { redirect_to_doctors_list }
        .on(:update_doctor_failed) { |doctor| render_form(doctor, :edit) }
        .call(@doctor.id, doctor_params)
    end

    def destroy
      authorize Doctor.destroy(params[:id])

      redirect_to doctors_path,
        notice: t(".success", model_name: "doctor")
    end

    private

    def find_doctor
      @doctor = Doctor.find_or_initialize_by(id: params[:id])
      authorize @doctor
    end

    def redirect_to_doctors_list
      redirect_to doctors_path,
        notice: t(".success", model_name: "doctor")
    end

    def render_form(doctor, action)
      @doctor = doctor
      flash[:error] = t(".failed", model_name: "doctor")
      render action
    end

    def doctor_params
      params.require(:doctor).permit(
        :given_name, :family_name, :email, :practitioner_type, :code, practice_ids: [],
        address_attributes: [
          :id, :street_1, :street_2, :city, :county, :postcode, :country
        ]
      )
    end
  end
end
