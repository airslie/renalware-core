class PeritonitisEpisodesController < ApplicationController

  before_action :load_patient, :only => [:new, :create, :edit, :update]

  def new
    @peritonitis_episode = PeritonitisEpisode.new
    @peritonitis_episode.medications.build(provider: :gp) 
  end

  def create
    @peritonitis_episode = PeritonitisEpisode.new(allowed_params)
    @peritonitis_episode.patient_id = @patient.id
    if @peritonitis_episode.save
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully added a peritonitis episode."
    else
      render :new
    end
  end

  def edit
    @peritonitis_episode = PeritonitisEpisode.find(params[:id])
    @peritonitis_episode.medications.build(provider: :gp) 
  end 

  def update
    @peritonitis_episode = PeritonitisEpisode.find(params[:id])
    if @peritonitis_episode.update(allowed_params)
      redirect_to pd_info_patient_path(@patient),
      :notice => "You have successfully updated a peritonitis episode."
    else
      render :edit 
    end
  end

  private
  def allowed_params
    params.require(:peritonitis_episode).permit(:user_id, :diagnosis_date, :start_treatment_date, :end_treatment_date, 
      :episode_type_id, :catheter_removed, :line_break, :exit_site_infection, :diarrhoea, :abdominal_pain, :fluid_description_id, 
      :white_cell_total, :white_cell_neutro, :white_cell_lympho, :white_cell_degen, :white_cell_other, :notes,
      :medications_attributes => [:id, :patient_id, :treatable_id, :treatable_type, :medicatable_id, :medicatable_type, :medication_type, :dose, :medication_route_id,
      :frequency, :notes, :date, :provider, :_destroy],
      :infection_organism_attributes => [:id, :organism_code_id, :sensitivity, :infectable_id, :infectable_type ]
      ) 
  end

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end 

end
