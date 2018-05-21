# frozen_string_literal: true

require_dependency "renalware/hospitals"

module Renalware
  module Hospitals
    class WardsController < BaseController
      def index
        authorize Ward, :index?
        wards = Ward.where(hospital_unit_id: unit.id).order(name: :asc).select(:id, :name)
        respond_to do |format|
          format.json { render json: wards.to_json }
          format.html { render locals: { wards: wards } }
        end
      end

      private

      def unit
        @unit ||= Unit.find(params[:unit_id])
      end
    end
  end
end
