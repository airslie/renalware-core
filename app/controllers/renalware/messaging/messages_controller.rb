require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class MessagesController < BaseController

      def new
        authorize Message, :new?
        render_new(build_message_form)
      end

      def create
        authorize Message, :create?
        form = MessageForm.new(message_params)

        if form.valid?
          SendMessage.call(author: author, patient: patient, form: form)
          flash.now[:notice] = "Message was successfully sent"
        else
          render_new(form)
        end
      end

      private

      def build_message_form
        Renalware::Messaging::MessageForm.new(
          subject: build_subject
        )
      end

      def build_subject
        replying? ? "Re: #{replying_to_message.subject}" : patient.to_s
      end

       def build_recipient_ids
        replying? ? message : patient.to_s
      end

      def replying_to_message
        return unless params.key?(:replying_to_message_id)
        @replying_to_message ||= Message.find(id: params[:replying_to_message_id])
      end

      def replying?
        replying_to_message.present?
      end

      def render_new(form)
        render :new,
                locals: {
                  form: form,
                  recipient_options: RecipientOptions.new(patient, current_user).to_a,
                  patient: patient
                },
                layout: false
      end

      def author
        Messaging.cast_author(current_user)
      end

      def patient
        Messaging.cast_patient(Patient.find(params[:patient_id]))
      end

      def message_params
        params
          .require(:messaging_message_form)
          .permit(:subject, :body, :urgent, recipient_ids: [])
      end
    end
  end
end
