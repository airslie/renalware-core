# frozen_string_literal: true

module Renalware
  module PD
    class PeritonitisEpisodePresenter < DumbDelegator
      def episode_types_summary
        return "Unknown" unless episode_types.any?
        episode_types.map do |type|
          type.peritonitis_episode_type_description.term
        end.join(", ")
      end
    end
  end
end
