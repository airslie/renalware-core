# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class LettersController < BaseController
      include Pagy::Backend
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/simple" }

      def index
        authorize Letters::Letter, :index?
      end
    end
  end
end
