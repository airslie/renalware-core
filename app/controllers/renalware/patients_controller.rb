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
      render
    end

    def update
      service = Patients::UpdatePatient.build

      service.on(:patient_updated) do |patient|
        redirect_to patient_clinical_summary_path(patient),
          notice: t(".success", model_name: "patient")
      end

      service.on(:patient_update_failed) do |patient|
        @patient = patient
        flash[:error] = t(".failed", model_name: "patient")
        render action: :edit
      end

      service.call(@patient.id, patient_params)
    end

    private

    def patient_params
      params.require(:patient).permit(
        :nhs_number, :local_patient_id, :family_name, :given_name, :sex,
        :ethnicity_id, :born_on, :paediatric_patient_indicator,
        :gp_practice_code, :pct_org_code, :hospital_centre_code, :primary_esrf_centre,
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
