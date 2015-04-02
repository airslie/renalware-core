class PatientsController < ApplicationController
  before_action :load_patient, :only => [:esrf_info, :pd_info, :death_update, :clinical_summary, :manage_medications, :problems, :modality,
    :medications_index, :demographics, :edit, :update]

  def esrf_info
    if @patient.esrf_info.blank?
      @esrf_info = @patient.build_esrf_info
    else
      @patient.patient_modality
    end
  end

  def pd_info
    @peritonitis_episodes = PeritonitisEpisode.where(:patient_id => @patient)
    @exit_site_infections = ExitSiteInfection.where(:patient_id => @patient)
  end

  def death
    @dead_patients = Patient.where("death_date IS NOT NULL", params[:death_date])  
  end

  def search
    @search = params[:patient_search]
    @patients = Patient.search("#{@search}*").records
    render :template => 'patients/index'
  end

  def modality
    if @patient.patient_modality.blank?
      @patient_modality = @patient.build_patient_modality
    else
      @patient.patient_modality
    end
  end

  def manage_medications
    @patient.active_medications.build( provider: :gp )
  end

  def problems
    @patient.patient_problems.build
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(allowed_params)
    if @patient.save
      redirect_to demographics_patient_path(@patient), :notice => "You have successfully added a new patient."
    else
      render :new
    end
  end

  def index
    @patients = Patient.all
  end

  def update
    if @patient.update(allowed_params)
      redirect_to params[:redirect_url] || clinical_summary_patient_path(@patient),
      :notice => "You have successfully updated a patient."
    else
      render params[:template] || :edit 
    end
  end

  private
  def allowed_params
    params.require(:patient).permit(:nhs_number, :local_patient_id, :surname,
      :forename, :sex, :ethnicity_id, :dob, :paediatric_patient_indicator, 
      :death_date, :first_edta_code_id, :second_edta_code_id, :death_details,
      :gp_practice_code, :pct_org_code, :hosp_centre_code, :primary_esrf_centre,
      :current_address_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :address_at_diagnosis_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :patient_event_attributes => [:date_time, :user_id, :description, :notes, :patient_event_type_id, :patient_id],
      :medications_attributes => [:id, :medicatable_id, :medicatable_type, :medication_type, :dose, :medication_route_id,
      :frequency, :notes, :date, :provider, :_destroy],
      :patient_problems_attributes => [:id, :patient_id, :snomed_id, :description, :date, :user_id, :deleted_at, :_destroy],
      :patient_modality_attributes => [:id, :patient_id, :user_id, :modality_code_id, :modality_reason_id, :modal_change_type, :notes, :date, :deleted_at],
      :esrf_info_attributes => [:id, :patient_id, :user_id, :date, :prd_code_id]
      )
  end

  def load_patient
    @patient = Patient.find(params[:id])
  end

end
