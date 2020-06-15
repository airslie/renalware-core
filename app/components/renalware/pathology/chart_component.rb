# frozen_string_literal: true

module Renalware
  module Pathology
    class ChartComponent < ApplicationComponent
      pattr_initialize [:current_user!, :patient!, :observation_description!]

      def chart_data
        @chart_data ||= begin
          Pathology.cast_patient(patient)
            .observations
            .where(description_id: observation_description.id)
            .order(:observed_at)
            .pluck([:observed_at, :result])
        end
      end

      # TODO: cache key should expire when a new observation arrives of this type
      def cache_key
        "#{patient.cache_key}/chart/#{observation_description.id}"
      end

      # Because we cache the component html inside the view sidecar, we want to
      # avoid implementing this method properly - ie checking if there anything
      # to render - as that would involve querying the database, thus negating
      # the befit of any caching.
      def render?
        true
      end

      def options
        {}
      end

      def dom_id
        @dom_id ||= ActionView::RecordIdentifier.dom_id(observation_description)
      end
    end
  end
end
