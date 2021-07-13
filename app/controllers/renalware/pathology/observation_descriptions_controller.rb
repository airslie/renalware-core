# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescriptionsController < BaseController
      include Pagy::Backend

      def index
        query = ObservationDescription
          .includes(:measurement_unit)
          .order(:code)
          .ransack(params[:q] || {})
        pagy, descriptions = pagy(query.result)
        authorize descriptions
        render locals: { descriptions: descriptions, pagy: pagy, query: query }
      end

      def edit
        render_edit find_authorise_description
      end

      def update
        description = find_authorise_description
        if description.update(description_params)
          redirect_to(
            pathology_observation_descriptions_path,
            notice: success_msg_for("observation descrition")
          )
        else
          render_edit(description)
        end
      end

      # GET
      # JSON - returns json to render a chart
      # HTML - returns markup for a modal dialog to display the chart. An async ajax query will then
      #        be issued (hitting this action again) to get the the JSON.
      # rubocop:disable Metrics/MethodLength
      def show
        authorize patient
        obs_desc = ObservationDescription.find(params[:id])
        respond_to do |format|
          format.json do
            chart_json = obs_desc.chart_series_json(
              patient_id: patient.id,
              start_date: Charts::PeriodMap[params[:period]]
            )
            render json: [chart_json]
          end
          format.html do
            render(
              locals: {
                patient: patient,
                observation_description: obs_desc
              },
              layout: false
            )
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      def render_edit(description)
        render :edit, locals: { description: description }
      end

      def find_authorise_description
        ObservationDescription.find(params[:id]).tap { |desc| authorize desc }
      end

      def description_params
        params
          .require(:pathology_observation_description)
          .permit(
            :name,
            :measurement_unit_id,
            :lower_threshold,
            :upper_threshold
          )
      end
    end
  end
end
