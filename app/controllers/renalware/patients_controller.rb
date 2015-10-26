module Renalware
  class PatientsController < BaseController
    include Renalware::Concerns::Pageable

    skip_after_action :verify_authorized, only: :show

    before_filter :prepare_paging, only: [:index]

    before_action :find_patient, only: [:show, :edit, :update]

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
      authorize @patient
    end

    def update
      authorize @patient
      if @patient.update(patient_params)
        redirect_to params[:redirect_url] || patient_clinical_summary_path(@patient), notice: params[:message]
      else
        render params[:template] || :edit
      end
    end

    def index
      @patients = @patient_search.result.page(@page).per(@per_page)
      authorize @patients
    end

    private
    def patient_params
      params.require(:patient).permit(:nhs_number, :local_patient_id, :surname,
        :forename, :sex, :ethnicity_id, :birth_date, :paediatric_patient_indicator,
        :gp_practice_code, :pct_org_code, :hosp_centre_code, :primary_esrf_centre,
        current_address_attributes: [:street_1, :street_2, :county, :country, :city, :postcode],
        address_at_diagnosis_attributes: [:street_1, :street_2, :county, :country, :city, :postcode],
        medications_attributes: [:id, :medicatable_id, :medicatable_type, :dose, :medication_route_id,
        :frequency, :notes, :start_date, :end_date, :provider, :_destroy]
        )
    end

    def find_patient
      @patient = Patient.find(params[:id])
    end
  end
end
