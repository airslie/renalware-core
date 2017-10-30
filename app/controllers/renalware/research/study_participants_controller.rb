require_dependency "renalware/research"

module Renalware
  module Research
    class StudyParticipantsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        authorize StudyParticipant, :index?
        render locals: { study: study, participants: participants }
      end

      def create
        participant = study.participants.build(participant_params)
        participant.joined_on ||= Time.zone.today
        authorize participant

        if participant.save
          render locals: { study: study, participants: participants }
        else
          render_new(participant)
        end
      end

      def new
        participant = study.participants.new(joined_on: Time.zone.today)
        authorize participant
        render_new(participant)
      end

      def destroy
        participant = find_and_authorise_participant
        participant.destroy
        redirect_to research_study_participants_path(study),
                    notice: "#{participant.patient} removed from the study"
      end

      def edit
        render_edit(find_and_authorise_participant)
      end

      # Don't update the participant id here (the patient) as that is immutable at this point.
      def update
        participant = find_and_authorise_participant
        if participant.update(participant_params_for_update)
          render locals: { study: study, participants: participants }
        else
          render_edit(participant)
        end
      end

      private

      def participants
        @participants ||= study.participants.page(page).per(per_page)
      end

      def render_edit(participant)
        render :new, locals: { participant: participant }, layout: false
      end

      def render_new(participant)
        render :new, locals: { participant: participant }, layout: false
      end

      def study
        @study ||= Study.find(params[:study_id])
      end

      def find_and_authorise_participant
        StudyParticipant.find(params[:id]).tap { |participant| authorize participant }
      end

      def participant_params_for_update
        participant_params.slice(:joined_on, :left_on)
      end

      def participant_params
        params
          .require(:research_study_participant)
          .permit(:participant_id, :joined_on, :left_on)
      end
    end
  end
end
