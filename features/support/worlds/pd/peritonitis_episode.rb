module World
  module PD::PeritonitisEpisode
    module Domain
      # @section commands
      #
      def record_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        patient.peritonitis_episodes.create!(
          diagnosis_date: diagnosed_on
        )
      end

      def revise_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        episode = patient.peritonitis_episodes.last!

        episode.update!(diagnosis_date: diagnosed_on)
      end

      # @section expectations
      #
      def expect_peritonitis_episodes_revisions_recorded(patient:)
        exit_site_infection = patient.peritonitis_episodes.last!
        organism = exit_site_infection.infection_organisms.last!
        medication = exit_site_infection.medications.last!

        expect(exit_site_infection.created_at).not_to eq(exit_site_infection.updated_at)
        expect(organism.created_at).not_to eq(organism.updated_at)
        expect(medication.created_at).not_to eq(medication.updated_at)
      end
    end
  end
end
