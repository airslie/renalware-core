class PatientsController < ApplicationController

  # Cancancan authorization filters
  skip_authorize_resource only: [:clinical_summary, :demographics, :esrf_info, :manage_medications, :pd_info, :problems]
  load_and_authorize_resource

  before_action :load_patient, only: [:esrf_info, :pd_info, :death_update, :clinical_summary, :manage_medications, :problems,
                                      :medications_index, :demographics, :edit, :update]

  def esrf_info
    if @patient.esrf_info.blank?
      @esrf_info = @patient.build_esrf_info
    else
      @patient.current_modality
    end
  end

  def pd_info
    @peritonitis_episodes = PeritonitisEpisode.where(:patient_id => @patient)
    @exit_site_infections = ExitSiteInfection.where(:patient_id => @patient)
  end

  def death
    @dead_patients = Patient.dead
  end

  def index
    @patients = (
      if params[:q].present?
        @patient_search.result
      else
        Patient.all
      end
    )
  end

  def manage_medications
    @patient.active_medications.build( provider: :gp )
  end

  def problems
    @patient.problems.build
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to demographics_patient_path(@patient), :notice => "You have successfully added a new patient."
    else
      render :new
    end
  end

  def update
    if @patient.update(patient_params)
      redirect_to params[:redirect_url] || clinical_summary_patient_path(@patient),
      :notice => "You have successfully updated a patient."
    else
      render params[:template] || :edit
    end
  end

  private
  def patient_params
    params.require(:patient).permit(:nhs_number, :local_patient_id, :surname,
      :forename, :sex, :ethnicity_id, :birth_date, :paediatric_patient_indicator,
      :death_date, :first_edta_code_id, :second_edta_code_id, :death_details,
      :gp_practice_code, :pct_org_code, :hosp_centre_code, :primary_esrf_centre,
      :current_address_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :address_at_diagnosis_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :event_attributes => [:date_time, :description, :notes, :event_type_id, :patient_id],
      :medications_attributes => [:id, :medicatable_id, :medicatable_type, :dose, :medication_route_id,
      :frequency, :notes, :date, :provider, :_destroy],
      :problems_attributes => [:id, :patient_id, :snomed_id, :description, :date, :user_id, :deleted_at, :_destroy],
      :esrf_info_attributes => [:id, :patient_id, :user_id, :date, :prd_code_id]
      )
  end

  def load_patient
    @patient = Patient.find(params[:id])
  end

end
