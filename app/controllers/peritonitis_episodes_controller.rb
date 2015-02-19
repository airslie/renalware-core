class PeritonitisEpisodesController < ApplicationController
  before_action :load_patient, :only => [:new, :create, :index, :edit, :update]

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

  # def index
  #   @peritonitis_episodes = @patient.peritonitis_episodes
  # end

  # def edit
  #   # binding.pry
  #   @peritonitis_episode = @patient.peritonitis_episodes.find(params[:id])
  # end 

  # def update
  #   if @patient.peritonitis_episodes.update(allowed_params)
  #     redirect_to params[:redirect_url] || pd_info_patient_path(@patient),
  #     :notice => "You have successfully updated a peritonitis episode."
  #   else
  #     render params[:template] || :edit 
  #   end
  # end

  private
  def allowed_params
    params.require(:peritonitis_episode).permit(:patient_id, :user_id, :start_treatment_date, :end_treatment_date, 
      :episode_type, :catheter_removed, :line_break, :exit_site_infection, :diarrhoea, :abdominal_pain, :fluid_description, 
      :diagnosis_date, :white_cell_total, :white_cell_neutro, :white_cell_lympho, :white_cell_degen, :white_cell_other, 
      :organism_1, :organism_2, :sensitivities, :notes, :antibiotic_1, :antibiotic_2, :antibiotic_3, :antibiotic_4, 
      :antibiotic_5, :antibiotic_1_route, :antibiotic_2_route, :antibiotic_3_route, :antibiotic_4_route, :antibiotic_5_route)
  end

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end 

end
