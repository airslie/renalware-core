module Renalware
  class PeritonitisEpisodesController < BaseController
    load_and_authorize_resource

    before_action :load_patient, :only => [:new, :create, :show, :edit, :update]
    before_action :load_peritonitis_episode, :only => [:show, :edit, :update]

    def new
      @peritonitis_episode = PeritonitisEpisode.new
    end

    def create
      @peritonitis_episode = PeritonitisEpisode.new(peritonitis_episode_params)
      @peritonitis_episode.patient_id = @patient.id
      if @peritonitis_episode.save
        redirect_to patient_pd_summary_path(@patient), :notice => "You have successfully added a peritonitis episode."
      else
        render :new
      end
    end

    def update
      if @peritonitis_episode.update(peritonitis_episode_params)
        redirect_to patient_peritonitis_episode_path(@patient, @peritonitis_episode),
        :notice => "You have successfully updated a peritonitis episode."
      else
        render :edit
      end
    end

    private
    def peritonitis_episode_params
      params.require(:peritonitis_episode).permit(:diagnosis_date, :treatment_start_date, :treatment_end_date,
        :episode_type_id, :catheter_removed, :line_break, :exit_site_infection, :diarrhoea, :abdominal_pain, :fluid_description_id,
        :white_cell_total, :white_cell_neutro, :white_cell_lympho, :white_cell_degen, :white_cell_other, :notes,
        infection_organisms_attributes: [:id, :organism_code_id, :sensitivity, :infectable_id, :infectable_type ],
        medications_attributes: [:id, :patient_id, :treatable_id, :treatable_type, :medicatable_id, :medicatable_type, :dose, :medication_route_id,
        :frequency, :notes, :start_date, :end_date, :provider, :_destroy]
      )
    end

    def load_peritonitis_episode
      @peritonitis_episode = PeritonitisEpisode.find(params[:id])
    end
  end
end
