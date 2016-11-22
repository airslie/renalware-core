require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class PeritonitisEpisodesController < BaseController
      include PresenterHelper

      before_action :load_patient, except: [:index, :destroy]

      def show
        peritonitis_episode = PeritonitisEpisode.for_patient(patient).find(params[:id])
        prescriptions = peritonitis_episode.prescriptions.ordered
        render locals: {
          patient: patient,
          peritonitis_episode: present(peritonitis_episode, PeritonitisEpisodePresenter),
          prescriptions: present(prescriptions, Medications::PrescriptionPresenter),
          treatable: present(peritonitis_episode, Medications::TreatablePresenter)
        }
      end

      def new
        render locals: {
          peritonitis_episode: PeritonitisEpisode.new,
          patient: patient
        }
      end

      def create
        save_episode
      end

      def edit
        render locals: {
          peritonitis_episode: PeritonitisEpisode.for_patient(patient).find(params[:id]),
          patient: patient
        }
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
        respond_to do |format|
          format.js do
            render locals: {
              peritonitis_episode: present(episode, PeritonitisEpisodePresenter),
              patient: patient
            }
          end
          format.html do
            url = patient_pd_peritonitis_episode_path(patient, episode)
            message = t(".success", model_name: "peritonitis episode")
            redirect_to url, notice: message
          end
        end
      end

      def save_failure(episode)
        flash[:error] = t(".failed", model_name: "peritonitis episode")
        action = action_name.to_sym == :create ? :new : :edit
        render action, locals: {
          peritonitis_episode: episode,
          patient: patient
        }
      end

      private

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
