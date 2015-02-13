class PatientsController < ApplicationController
  before_action :load_patient, :only => [:esrf_info, :pd_info, :death_update, :clinical_summary, :medications, :problems, :modality,
    :medications_index, :demographics, :edit, :update]

  def esrf_info
    if @patient.esrf_info.blank?
      @esrf_info = @patient.build_esrf_info
    else
      @patient.patient_modality
    end
  end

  def pd_info
    @peritonitis_episodes = @patient.peritonitis_episodes.build
  end

  def death
    @dead_patients = Patient.where("death_date IS NOT NULL", params[:death_date])  
  end

  def search
    @search = params[:patient_search]
    @patients = Patient.search("#{@search}*").records
    render :template => 'patients/index'
  end

  def clinical_summary
    @patient_events = PatientEvent.all
    @patient_medications = PatientMedication.all
  end

  def modality
    if @patient.patient_modality.blank?
      @patient_modality = @patient.build_patient_modality
    else
      @patient.patient_modality
    end
  end

  def medications
    @patient.active_patient_medications.build(:provider => :gp,
      :medication_type => "Drug")
    @drugs = Drug.standard
  end

  def problems
    @patient.patient_problems.build
  end

  def medications_index
    @patient_medications = PatientMedication.all
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
      :patient_medications_attributes => [:id, :medication_id, :medication_type, :dose, :route,
      :frequency, :notes, :date, :provider, :_destroy],
      :patient_problems_attributes => [:id, :patient_id, :snomed_id, :description, :date, :user_id, :deleted_at, :_destroy],
      :patient_modality_attributes => [:id, :patient_id, :user_id, :modality_code_id, :modality_reason_id, :modal_change_type, :notes, :date, :deleted_at],
      :esrf_info_attributes => [:id, :patient_id, :user_id, :date, :prd_code_id],
      :peritonitis_episode_attributes => [:id, :patient_id, :user_id, :start_treatment_date, :end_treatment_date, 
        :episode_type, :catheter_removed, :line_break, :exit_site_infection, :diarrhoea, :abdominal_pain, :fluid_description, 
        :diagnosis_date, :white_cell_total, :white_cell_neutro, :white_cell_lympho, :white_cell_degen, :white_cell_other, 
        :organism_1, :organism_2, :sensitivities, :notes, :antibiotic_1, :antibiotic_2, :antibiotic_3, :antibiotic_4, 
        :antibiotic_5, :antibiotic_1_route, :antibiotic_2_route, :antibiotic_3_route, :antibiotic_4_route, :antibiotic_5_route] 
      )
  end

  def load_patient
    @patient = Patient.find(params[:id])
  end

end
