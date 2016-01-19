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

      def record_organism_for(patient:, organism_name:)
        code = Renalware::OrganismCode.find_by!(name: organism_name)
        infection = patient.exit_site_infections.last!

        infection.infection_organisms.create!(organism_code: code)
      end

      def revise_organism_for(patient:, sensitivity:)
        infection = patient.exit_site_infections.last!
        organism = infection.infection_organisms.last!

        organism.update!(sensitivity: sensitivity)
      end

      def record_medication_for(patient:, drug_name:, dose:,
                               route_name:, frequency:, starts_on:, provider:)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        route = Renalware::MedicationRoute.find_by!(name: route_name)
        infection = patient.exit_site_infections.last!

        infection.medications.create!(
          patient: patient,
          drug: drug,
          dose: dose,
          medication_route: route,
          frequency: frequency,
          start_date: starts_on,
          provider: provider.downcase
        )
      end

      def revise_medication_for(patient:, drug_name:)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        infection = patient.exit_site_infections.last!
        medication = infection.medications.last!

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

      def record_organism_for(patient:, organism_name:)
        click_link "Add Infection Organism"
        wait_for_ajax

        within "#new_infection_organism" do
          select(organism_name, from: "Organism")
          click_on "Save"
        end

        wait_for_ajax
      end

      def revise_organism_for(patient:, sensitivity:)
        within "#infection-organisms" do
          click_on "Edit"
        end
        fill_in "Sensitivity", with: sensitivity
        click_on "Save"

        wait_for_ajax
      end

      def record_medication_for(patient:, drug_name:, dose:, route_name:,
                                frequency:, starts_on:, provider:)
        click_link "Add Medication"
        wait_for_ajax

        within "#new_medication" do
          select(drug_name, from: "Select Drug")
          fill_in "Dose", with: dose
          select(route_name, from: "Route")
          fill_in "Frequency", with: frequency
          fill_in "Prescribed on", with: starts_on
          click_on "Save"
        end

        wait_for_ajax
      end

      def revise_medication_for(patient:, drug_name:)
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
