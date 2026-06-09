module Renalware
  module Heidi
    class GenerateOutputs
      def initialize(session:, document_template_id:, client: OutputsClient.new)
        @session = session
        @document_template_id = document_template_id
        @client = client
      end

      def call
        session.update!(outputs_error: nil)
        generate_document if document_template_id.present?
        generate_structured_response
        fetch_clinical_codes

        session.update!(outputs_generated_at: Time.zone.now)
        session
      rescue StandardError => e
        session.update!(outputs_generated_at: Time.zone.now, outputs_error: e.message)
        session
      end

      private

      attr_reader :session, :document_template_id, :client

      def generate_document
        response = client.create_document(
          session.user,
          session.heidi_session_id,
          template_id: document_template_id
        )
        raise response.error if response.failed?

        session.update!(
          document_template_id:,
          document_content_type: response.body["content_type"],
          document_content: response.body["content"],
          document_response: response.body
        )
      end

      def generate_structured_response
        response = client.generate_custom_template_response(
          session.user,
          session.heidi_session_id,
          StructuredOutputTemplate.call
        )
        raise response.error if response.failed?

        session.update!(structured_response: response.body)
      end

      def fetch_clinical_codes
        response = client.clinical_codes(session.user, session.heidi_session_id)
        raise response.error if response.failed?

        session.update!(clinical_codes_response: response.body)
      end
    end
  end
end
