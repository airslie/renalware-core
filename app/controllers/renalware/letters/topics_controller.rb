# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class TopicsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        topics = Topic.with_deleted.ordered
        authorize topics
        render locals: { topics: topics }
      end

      def new
        topic = Topic.new
        authorize topic
        render_new topic
      end

      def create
        topic = Topic.new(topic_params)
        authorize topic
        if topic.save
          redirect_to letters_topics_path
        else
          render_new topic
        end
      end

      def edit
        render_edit find_and_authorise_topic
      end

      def update
        topic = find_and_authorise_topic
        if topic.update(topic_params)
          redirect_to letters_topics_path
        else
          render_edit topic
        end
      end

      def destroy
        find_and_authorise_topic.destroy
        redirect_to letters_topics_path
      end

      def sort
        authorize Topic, :sort?
        ids = params[:letters_topic]
        Topic.sort(ids)
        render json: ids
      end

      private

      def render_new(topic)
        render "new", locals: { topic: topic }
      end

      def render_edit(topic)
        render "edit", locals: { topic: topic }
      end

      def topic_params
        params.require(:topic).permit(:text, :position)
      end

      def find_and_authorise_topic
        Topic.find(params[:id]).tap { |topic| authorize topic }
      end
    end
  end
end
