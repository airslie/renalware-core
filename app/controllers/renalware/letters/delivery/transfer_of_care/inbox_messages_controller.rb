# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class InboxMessagesController < BaseController
      include Pagy::Backend

      def index
        authorize Transmission, :index?
        response = fetch_ids_of_inbox_messages_to_download
        render locals: { message_ids: response.body["messages"] }
      end

      def show
        authorize Transmission, :show?
        response = fetch_message(params[:id])
        render locals: { response: response }
      end

      # Process
      def update
        authorize Transmission, :show?
        message_id = params[:id]
        Jobs::DownloadMessageJob.perform_now(message_id)
        redirect_to letters_delivery_transfer_of_care_inbox_messages_path
      end

      private

      def fetch_ids_of_inbox_messages_to_download
        API::LogOperation.new(:check_inbox).call { API::Client.check_inbox }
      end

      def fetch_message(id)
        API::LogOperation.new(:download_message).call { API::Client.download_message(id) }
      end
    end
  end
end
