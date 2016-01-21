module World
  module PD::PeritonitisEpisode
    module Domain
      # @section helpers
      #
      def episode_for(patient)
        patient.peritonitis_episodes.last!
      end

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
      def expect_peritonitis_episode_to_be_recorded(patient:)
        episode = episode_for(patient)
        organism = episode.infection_organisms.last
        medication = episode.medications.last

        expect(episode).to be_present
        expect(organism).to be_present
        expect(medication).to be_present
      end

      def expect_peritonitis_episodes_revisions_recorded(patient:)
        exit_site_infection = patient.peritonitis_episodes.last!
        organism = exit_site_infection.infection_organisms.last!
        medication = exit_site_infection.medications.last!

        expect(exit_site_infection.created_at).not_to eq(exit_site_infection.updated_at)
        expect(organism.created_at).not_to eq(organism.updated_at)
        expect(medication.created_at).not_to eq(medication.updated_at)
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def record_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        login_as user

        visit new_patient_peritonitis_episode_path(patient)
        fill_in "Diagnosed on", with: diagnosed_on
        click_on "Save"
      end

      def peritonitis_episode_drug_selector
        -> (drug_name) {
          find("select#medication_drug_id optgroup[label='Peritonitis']")
            .find(:option, text: drug_name).select_option
        }
      end
    end
  end
end
