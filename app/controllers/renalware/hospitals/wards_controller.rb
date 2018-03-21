# frozen_string_literal: true

require_dependency "renalware/hospitals"

module Renalware
  module Hospitals
    class WardsController < BaseController
      def index
        authorize Ward, :index?
        unit = Unit.find(params[:unit_id])
        wards = Ward.where(hospital_unit_id: unit.id).order(name: :asc).select(:id, :name)
        respond_to do |format|
          format.json do
            render json: wards.to_json
          end
        end
      end
    end
  end
end
