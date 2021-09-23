# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"
require "collection_presenter"

module Renalware
  module HD
    class StationsController < BaseController
      include PresenterHelper
      skip_after_action :verify_policy_scoped

      def index
        stations = Station.for_unit(unit_id).includes(:location).ordered
        authorize stations
        render locals: {
          unit_id: unit_id,
          stations: present(stations, StationPresenter)
        }
      end

      def new
        station = Station.new(hospital_unit_id: unit_id)
        station.by = current_user
        authorize station
        render_new(station)
      end

      def create
        station = Station.new(station_params.merge!(hospital_unit_id: unit_id))
        authorize station
        if station.save_by(current_user)
          redirect_to hd_unit_stations_path(unit_id: unit_id), notice: success_msg_for("station")
        else
          render_new(station)
        end
      end

      def edit
        authorize station
        render_edit(station)
      end

      def update
        authorize station
        if station.update_by(current_user, station_params)
          redirect_to hd_unit_stations_path(unit_id: unit_id), notice: success_msg_for("station")
        else
          render_edit(station)
        end
      end

      def sort
        authorize Station, :sort?
        ids = params["hd-station"]
        Station.sort(ids)
        render json: ids
      end

      private

      def render_new(station)
        render :new, locals: { unit_id: unit_id, station: station }
      end

      def render_edit(station)
        render :edit, locals: { unit_id: unit_id, station: station }
      end

      def unit_id
        params[:unit_id]
      end

      def station
        @station ||= Station.find(params[:id])
      end

      def station_params
        params.require(:hd_station).permit(:name, :location_id)
      end
    end
  end
end
