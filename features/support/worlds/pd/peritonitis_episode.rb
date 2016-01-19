module World
  module PD::PeritonitisEpisode
    module Domain
      # @ section commands
      #
      def record_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        patient.peritonitis_episodes.create!(
          diagnosis_date: diagnosed_on
        )
      end
    end
  end
end
