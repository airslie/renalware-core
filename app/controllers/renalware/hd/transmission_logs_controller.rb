# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"
require "collection_presenter"

module Renalware
  module HD
    class TransmissionLogsController < BaseController
      include PresenterHelper
      include Renalware::Concerns::Pageable

      # NB be sure not to select the payload as this will slow things down.
      # The payload is loaded by clicking on a link in the table
      def index
        logs = TransmissionLog
          .order(created_at: :desc)
          .select(TransmissionLog.attribute_names - [:payload])
          .page(page).per(per_page)
        authorize logs
        render locals: { logs: logs }
      end

      def show
        log = TransmissionLog.find(params[:id])
        authorize log
        respond_to do |format|
          format.xml { render xml: log.payload }
        end
      end
    end
  end
end
