module Renalware
  class PatientsController < BaseController
    include Renalware::Concerns::Pageable

    skip_after_action :verify_authorized, only: [:show, :search]
    before_action :prepare_paging, only: [:index]
    before_action :find_patient, only: [:show, :edit, :update]

    def index
      @patients = @patient_search.result.page(@page).per(@per_page)
      authorize @patients
    end

    def search
      query = Patients::SearchQuery.new(term: params[:term])
      render json: query.call.to_json
    end

    def new
      @patient = Patient.new
      authorize @patient
    end

    def create
      @patient = Patient.new(patient_params)
      authorize @patient

      if @patient.save
        redirect_to patient_path(@patient),
          notice: t(".success", model_name: "patient")
      else
        flash[:error] = t(".failed", model_name: "patient")
        render :new
      end
    end

    def edit
      render_form(@patient, :edit)
    end

    def update
      Patients::UpdatePatient.build
        .subscribe(self)
        .call(@patient.id, patient_params)
    end

    def update_patient_successful(patient)
      redirect_to_clinical_summary(patient)
    end

    def update_patient_failed(patient)
      flash[:error] = t(".failed", model_name: "patient")
      render_form(patient, :edit)
    end

    private

    def patient_params
      params.require(:patient).permit(
        :nhs_number, :local_patient_id, :family_name, :given_name, :sex,
        :ethnicity_id, :born_on, :paediatric_patient_indicator,
        :gp_practice_code, :pct_org_code, :hospital_centre_code, :primary_esrf_centre,
        current_address_attributes: [
          :name, :organisation_name, :street_1, :street_2, :county, :country, :city, :postcode
        ],
        address_at_diagnosis_attributes: [
          :name, :organisation_name, :street_1, :street_2, :county, :country, :city, :postcode
        ]
      )
    end

    def find_patient
      @patient = Patient.find(params[:id])
      authorize @patient
    end

    def redirect_to_clinical_summary(patient)
      redirect_to patient_clinical_summary_path(patient),
        notice: t(".success", model_name: "patient")
    end

    def render_form(patient, action)
      @patient = patient
      render action
    end
  end
end
