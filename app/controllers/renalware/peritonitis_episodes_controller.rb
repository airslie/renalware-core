module Renalware
  class PeritonitisEpisodesController < BaseController
    include PresenterHelper

    before_action :load_patient, :except => [:index, :destroy]
    before_action :load_peritonitis_episode, :only => [:show, :edit, :update]

    def show
      @medications = present(
        @peritonitis_episode.medications.ordered,
        Medications::MedicationPresenter
      )
      @treatable = Medications::TreatablePresenter.new(@peritonitis_episode)
    end

    def new
      @peritonitis_episode = PeritonitisEpisode.new
    end

    def create
      @peritonitis_episode = PeritonitisEpisode.new(peritonitis_episode_params)
      @peritonitis_episode.patient_id = @patient.id
      if @peritonitis_episode.save
        redirect_to patient_peritonitis_episode_path(@patient, @peritonitis_episode),
          notice: t(".success", model_name: "peritonitis episode")
      else
        flash[:error] = t(".failed", model_name: "peritonitis episode")
        render :new
      end
    end

    def edit
      render
    end

    def update
      @peritonitis_episode.update(peritonitis_episode_params)
    end

    private

    def peritonitis_episode_params
      params.require(:peritonitis_episode).permit(
        :diagnosis_date, :treatment_start_date, :treatment_end_date,
        :episode_type_id, :catheter_removed, :line_break, :exit_site_infection,
        :diarrhoea, :abdominal_pain, :fluid_description_id, :white_cell_total,
        :white_cell_neutro, :white_cell_lympho, :white_cell_degen,
        :white_cell_other, :notes
      )
    end

    def load_peritonitis_episode
      @peritonitis_episode = PeritonitisEpisode.for_patient(@patient).find(params[:id])
    end
  end
end
