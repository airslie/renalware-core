module Renalware
  module System
    class UserFeedbackController < BaseController
      def new
        feedback = UserFeedback.new
        authorize feedback
        render_new(feedback)
      end

      def create
        feedback = UserFeedback.new(user_feedback_params)
        feedback.author = current_user
        authorize feedback

        if feedback.save
          redirect_to root_url, notice: "Feedback registered, thank you"
        else
          render_new(feedback)
        end
      end

      private

      def render_new(feedback)
        render :new, locals: { feedback: feedback }
      end

      def user_feedback_params
        params
          .require(:feedback)
          .permit(:comment, :category)
      end
    end
  end
end
