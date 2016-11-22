require_dependency "renalware/pd"

module Renalware
  module PD
    class PeritonitisEpisodesController < BaseController
      include PresenterHelper

      before_action :load_patient, except: [:index, :destroy]

      def show
        @peritonitis_episode = PeritonitisEpisode.for_patient(patient).find(params[:id])
        @prescriptions = present(
          @peritonitis_episode.prescriptions.ordered,
          Medications::PrescriptionPresenter
        )
        @treatable = present(@peritonitis_episode, Medications::TreatablePresenter)
      end

      def new
        @peritonitis_episode = PeritonitisEpisode.new
      end

      def create
        save_episode
      end

      def edit
        @peritonitis_episode = PeritonitisEpisode.for_patient(patient).find(params[:id])
        render
      end

      def update
        save_episode
      end

      def save_episode
        command = SavePeritonitisEpisode.new(patient: patient)
        command.subscribe(self)
        command.call(id: params[:id], params: peritonitis_episode_params)
      end

      def save_success(episode)
        @peritonitis_episode = episode
        respond_to do |format|
          format.js
          format.html do
            url = patient_pd_peritonitis_episode_path(patient, episode)
            message = t(".success", model_name: "peritonitis episode")
            redirect_to url, notice: message
          end
        end
      end

      def save_failure(episode)
        @peritonitis_episode = episode
        flash[:error] = t(".failed", model_name: "peritonitis episode")
        action = action_name.to_sym == :create ? :new : :edit
        render action
      end

      def peritonitis_episode_params
        params
          .require(:pd_peritonitis_episode)
          .permit(
            :diagnosis_date, :treatment_start_date, :treatment_end_date,
            :catheter_removed, :line_break, :exit_site_infection,
            :diarrhoea, :abdominal_pain, :fluid_description_id, :white_cell_total,
            :white_cell_neutro, :white_cell_lympho, :white_cell_degen,
            :white_cell_other, :notes, { episode_types: [] }
          )
      end
    end
  end
end
