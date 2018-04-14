require_dependency "renalware/messaging"

module Renalware
  module Messaging
    module Internal
      class MessagesController < BaseController
        include Renalware::Concerns::Pageable
        include PresenterHelper

        def new
          authorize Message, :new?
          form = MessageFormBuilder.new(patient: patient, params: params).call
          render_new(form)
        end

        def create
          authorize Message, :create?
          form = MessageForm.new(message_params)

          if form.valid?
            message = SendMessage.call(author: author, patient: patient, form: form)
            flash.now[:notice] = "Message was successfully sent"
            render_create(message)
          else
            render_new(form)
          end
        end

        private

        def message_we_are_replying_to(message)
          return if message.replying_to_message_id.blank?
          MessagePresenter.new(message.replying_to_message)
        end

        def render_new(form)
          render :new,
                  locals: {
                    form: form,
                    recipient_options: RecipientOptions.new(patient, author).to_a,
                    patient: patient
                  },
                  layout: false
        end

        def render_create(message)
          render locals: {
            message: MessagePresenter.new(message),
            original_message: message_we_are_replying_to(message)
          }
        end

        def author
          Messaging::Internal.cast_author(current_user)
        end

        def patient
          Messaging.cast_patient(Patient.find(params[:patient_id]))
        end

        def message_params
          params
            .require(:internal_message)
            .permit(:subject, :body, :urgent, :replying_to_message_id, recipient_ids: [])
        end
      end
    end
  end
end
