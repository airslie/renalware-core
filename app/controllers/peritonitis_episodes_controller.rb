class PeritonitisEpisodesController < ApplicationController

  before_action :load_patient, :only => [:new, :create]

  def new
    @peritonitis_episode = PeritonitisEpisode.new
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
    @patient = Patient.find(params[:id])
    @peritonitis_episode = PeritonitisEpisode.find(params[:id])
  end 

  def update
    @patient = Patient.find(params[:id])
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
    params.require(:peritonitis_episode).permit(:patient_id, :user_id, :start_treatment_date, :end_treatment_date, 
      :episode_type_id, :catheter_removed, :line_break, :exit_site_infection, :diarrhoea, :abdominal_pain, :fluid_description_id, 
      :diagnosis_date, :white_cell_total, :white_cell_neutro, :white_cell_lympho, :white_cell_degen, :white_cell_other, 
      :organism_1_id, :organism_2_id, :sensitivities, :notes, :antibiotic_1_id, :antibiotic_2_id, :antibiotic_3_id, :antibiotic_4_id, 
      :antibiotic_5_id, :antibiotic_1_route, :antibiotic_2_route, :antibiotic_3_route, :antibiotic_4_route, :antibiotic_5_route)
  end

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end 

end
