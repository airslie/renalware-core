# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class LettersController < BaseController
      include Pagy::Backend
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/simple" }

      def index
        authorize Letters::Letter, :index?

        # We need to get
        # letters
        # - transmission 1
        # - transmission 2
        letters = Letters::Letter.approved_or_completed
        render locals: { letters: letters }
      end
    end
  end
end
