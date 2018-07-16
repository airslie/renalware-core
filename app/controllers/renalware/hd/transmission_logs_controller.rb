# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"
require "collection_presenter"

module Renalware
  module HD
    class TransmissionLogsController < BaseController
      include PresenterHelper
      include Renalware::Concerns::Pageable

      def index
        logs = TransmissionLog.all.page(page).per(per_page)
        authorize logs
        render locals: { logs: logs }
      end
    end
  end
end
