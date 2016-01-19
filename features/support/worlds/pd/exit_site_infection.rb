module World
  module PD::ExitSiteInfection
    module Domain
      # @ section commands
      #
      def record_exit_site_infection_for(patient:, user:, diagnosed_on:, outcome:)
        patient.exit_site_infections.create(
          diagnosis_date: diagnosed_on,
          outcome: outcome
        )
      end

      def revise_exit_site_infection_for(patient:, user:, diagnosed_on:)
        infection = patient.exit_site_infections.last!

        infection.update!(diagnosis_date: diagnosed_on)
      end

      def revise_medication_for(treatable:, drug_name:)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        medication = treatable.medications.last!

        medication.update!(drug: drug)
      end

      def terminate_organism_for(patient:, user:)
        infection = patient.exit_site_infections.last!
        organism = infection.infection_organisms.last!

        organism.destroy

        expect(infection.infection_organisms).to be_empty
      end

      def terminate_medication_for(patient:, user:)
        infection = patient.exit_site_infections.last!
        medication = infection.medications.last!

        medication.destroy
        expect(medication).to be_deleted
      end

      # @ section expectations
      #
      def expect_exit_site_infection_to_recorded(patient:)
        exit_site_infection = patient.exit_site_infections.last
        organism = exit_site_infection.infection_organisms.last
        medication = exit_site_infection.medications.last

        expect(exit_site_infection).to be_present
        expect(organism).to be_present
        expect(medication).to be_present
      end

      def expect_exit_site_infections_revisions_recorded(patient:)
        exit_site_infection = patient.exit_site_infections.last!
        organism = exit_site_infection.infection_organisms.last!
        medication = exit_site_infection.medications.last!

        expect(exit_site_infection.created_at).not_to eq(exit_site_infection.updated_at)
        expect(organism.created_at).not_to eq(organism.updated_at)
        expect(medication.created_at).not_to eq(medication.updated_at)
      end
    end

    module Web
      include Domain

      # @ section commands
      #
      def record_exit_site_infection_for(patient:, user:, diagnosed_on:, outcome:)
        login_as user

        visit new_patient_exit_site_infection_path(patient)
        fill_in "Diagnosed on", with: diagnosed_on
        fill_in "Outcome", with: outcome
        click_on "Save"
      end

      def revise_exit_site_infection_for(patient:, user:, diagnosed_on:)
        login_as user

        visit patient_exit_site_infection_path(patient, patient.exit_site_infections.last!)
        within "#infection" do
          click_on "Edit"
        end
        fill_in "Diagnosed on", with: diagnosed_on
        click_on "Save"

        wait_for_ajax
      end

      def revise_medication_for(treatable:, drug_name:)
        within "#medications" do
          click_on "Edit"
        end

        select(drug_name, from: "Select Drug")
        click_on "Save"
        wait_for_ajax
      end

      def terminate_medication_for(patient:, user:)
        within "#medications" do
          click_on "Terminate"
        end
        wait_for_ajax

        infection = patient.exit_site_infections.last!
        medication = infection.medications.with_deleted.last!

        expect(medication).to be_deleted
      end

      def terminate_organism_for(patient:, user:)
        within "#infection-organisms" do
          click_on "Terminate"
        end
        wait_for_ajax

        infection = patient.exit_site_infections.last!
        expect(infection.infection_organisms).to be_empty
      end
    end
  end
end
