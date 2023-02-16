# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class TransmissionsController < BaseController
      include Pagy::Backend

      def index
        authorize Transmission, :index?
        search = Transmission
          .order(created_at: :desc)
          .includes(:operations)
          .includes(letter: :patient)
          .ransack(params.fetch(:q, {}))
        pagy, transmissions = pagy(search.result)
        authorize transmissions
        render locals: { transmissions: transmissions, pagy: pagy, search: search }
      end

      def show
        transmission = Transmission.find(params[:id])
        authorize transmission
        render locals: { transmission: transmission }
      end
    end
  end
end
