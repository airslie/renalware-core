# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescriptionsController < BaseController
      include Pagy::Backend
      skip_after_action :verify_policy_scoped

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
