module Renalware
  module Feeds
    class QueuedOutgoingDocumentsController < API::TokenAuthenticatedAPIController
      api_scope API::Credential::OUTGOING_DOCUMENTS_READ, only: %i(index show)
      api_scope API::Credential::OUTGOING_DOCUMENTS_WRITE, only: :update

      skip_before_action :track_ahoy_visit
      protect_from_forgery only: []
      after_action :track_action, only: []

      # Renders a JSON array of documents queued to be processed by Mirth. Mirth will query this
      # endpoint and for each item call #show
      def index
        documents = OutgoingDocument.queued_for_processing
        render json: {
          documents: documents.map { |doc| document_json(doc) }
        }
      end

      # Called by Mirth, renders json containing the HL7 document to be enqueued in Mirth.
      def show
        document = OutgoingDocument.queued_for_processing.find(params[:id])

        render json: {
          id: document.id,
          state: document.state,
          body: renderable(document)
        }
      end

      def update
        document = OutgoingDocument.queued_for_processing.find(params[:id])

        return render_invalid_result unless update_document_for_outcome(document)

        render json: {
          result: "OK",
          state: document.state
        }
      end

      private

      # Wider issues to revisit:
      # - claim/lease queued documents so concurrent Mirth pollers cannot process the same item
      # - make updates idempotent with an external Mirth/TIE message identifier
      # - distinguish definite failures from unknown delivery outcomes, such as TIE timeouts
      def document_update_outcome
        case params[:result]
        when nil, "", "sent", "processed", "success" then :processed
        when "failed", "errored", "error" then :errored
        end
      end

      def update_document_for_outcome(document)
        case document_update_outcome
        when :processed then mark_document_as_processed(document)
        when :errored then mark_document_as_errored(document)
        end
      end

      def render_invalid_result
        render json: { error: "Invalid result" }, status: :unprocessable_content
      end

      def mark_document_as_processed(document)
        document.update!(state: :processed, by: current_user)
      end

      def mark_document_as_errored(document)
        document.update!(
          state: :errored,
          by: current_user,
          error: params[:error],
          error_code: params[:error_code],
          errored_at: Time.zone.now,
          comments: params[:comments]
        )
      end

      def document_json(document)
        protocol = Rails.env.local? || ENV.fetch("HTTP_ONLY_LINKS_IN_JSON", false) ? :http : :https
        {
          id: document.id,
          state: document.state,
          url: feeds_queued_outgoing_document_url(document, protocol: protocol, format: :json)
        }
      end

      # document.renderable is polymorphic and can be a Letter, Event, etc.
      def renderable(document)
        renderable = document.renderable

        if renderable.class.name.at("Events::")
          renderable = Events::EventPdfPresenter.new(renderable)
        end

        HL7DocumentMessageBuilder.call(renderable:, document:).to_s + "\r"
      end
    end
  end
end
