# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class HelpController < BaseController
      def show
        authorize Transmission, :show?
      end
    end
  end
end
