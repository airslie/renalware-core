module Renalware
  module Research
    class ParticipationsController < BaseController
      helper Renalware::ResearchHelper
      include Pagy::Backend

      def index
        authorize Participation, :index?
        query = ParticipationQuery.new(study: study, options: params[:q])
        pagy, participations = pagy(query.call)
        render locals: {
          study: study,
          participations: participations,
          query: query.search,
          pagy: pagy
        }
      end

      def show
        authorize Participation, :show?
        redirect_to research.study_participations_path(study)
      end

      def new
        participation = build_participation
        authorize participation
        render_new(participation)
      end

      def edit
        render_edit(find_and_authorise_participation)
      end

      def create
        participation = build_participation(participation_params)
        authorize participation

        if participation.save
          redirect_to(
            research.study_participations_path(study),
            notice: success_msg_for("participant")
          )
        else
          render_new(participation)
        end
      end

      # Don't update the participant id here (the patient) as that is immutable at this point.
      def update
        participation = find_and_authorise_participation
        if participation.update(participation_params_for_update)
          redirect_to(
            research.study_participations_path(study),
            notice: success_msg_for("participant")
          )
        else
          render_edit(participation)
        end
      end

      def destroy
        participation = find_and_authorise_participation
        participation.destroy
        redirect_to research.study_participations_path(study),
                    notice: "#{participation.patient} removed from the study"
      end

      private

      def participations
        @participations ||= study.participations.includes(:patient).page(page).per(per_page)
      end

      def build_participation(params = {})
        participation_class = study.class.participation_class
        participation_class.new(params).tap do |participation|
          participation.study = study
          participation.joined_on ||= Time.zone.today
        end
      end

      def render_edit(participation)
        render :edit, locals: { participation: participation }
      end

      def render_new(participation)
        render :new, locals: { participation: participation }
      end

      def study
        @study ||= Study.find(params[:study_id])
      end

      def find_and_authorise_participation
        Participation.find(params[:id]).tap { |participation| authorize participation }
      end

      def participation_params_for_update
        participation_params.slice(:joined_on, :left_on, :external_reference, :document)
      end

      def participation_params
        params
          .require(:participation)
          .permit(:patient_id, :joined_on, :left_on, :external_reference, document: {})
      end
    end
  end
end
