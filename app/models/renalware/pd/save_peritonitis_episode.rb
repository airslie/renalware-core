module Renalware
  module PD
    class SavePeritonitisEpisode
      include Wisper::Publisher

      def initialize(patient:)
        @patient = patient
      end

      def call(id: nil, params:)
        episode = find_or_build_episode(id: id, params: filtered_params(params))
        success = save_episode(episode, params)
        success ? broadcast(:save_success, episode) : broadcast(:save_failure, episode)
        success
      end

      private

      attr_reader :patient

      def filtered_params(params)
        params.except(:episode_types)
      end

      def episodes
        patient.peritonitis_episodes
      end

      def find_or_build_episode(id:, params:)
        episode = if id.present?
                    episodes.find_by!(id: id)
                  else
                    episodes.build(params)
                  end
        episode.assign_attributes(params)
        episode
      end

      def save_episode(episode, params)
        PeritonitisEpisode.transaction do
          episode.save && save_episode_types(episode.episode_types, params)
        end
      end

      def save_episode_types(episode_types, params)
        episode_type_desc_ids = params.fetch(:episode_types, [])
        episode_types.destroy_all
        episode_type_desc_ids.each do |desc_id|
          episode_types.create!(peritonitis_episode_type_description_id: desc_id)
        end
        true
      end
    end
  end
end
