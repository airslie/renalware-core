module Renalware
  class PatientsController < BaseController
    include Renalware::Concerns::Pageable

    skip_after_action :verify_authorized, only: :show
    before_action :prepare_paging, only: [:index]
    before_action :find_patient, only: [:show, :edit, :update]

    def index
      @patients = @patient_search.result.page(@page).per(@per_page)
      authorize @patients
    end

    def new
      @patient = Patient.new
      authorize @patient
    end

    def create
      @patient = Patient.new(patient_params)
      authorize @patient

      if @patient.save
        redirect_to patient_path(@patient), notice: "You have successfully added a new patient."
      else
        render :new
      end
    end

    def edit
      render
    end

    def update
      if @patient.update(patient_params)
        redirect_to patient_clinical_summary_path(@patient),
          notice: "You have successfully updated a patient's demographics"
      else
        render :edit
      end
    end

    private

    def patient_params
      params.require(:patient).permit(
        :nhs_number, :local_patient_id, :family_name, :given_name, :sex,
        :ethnicity_id, :born_on, :paediatric_patient_indicator,
        :gp_practice_code, :pct_org_code, :hosp_centre_code, :primary_esrf_centre,
        current_address_attributes: [
          :street_1, :street_2, :county, :country, :city, :postcode
        ],
        address_at_diagnosis_attributes: [
          :street_1, :street_2, :county, :country, :city, :postcode
        ]
      )
    end

    def find_patient
      @patient = Patient.find(params[:id])
      authorize @patient
    end
  end
end
