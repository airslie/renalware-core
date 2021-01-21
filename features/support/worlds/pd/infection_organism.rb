# frozen_string_literal: true

module World
  module PD::InfectionOrganism
    module Domain
      # @ section commands
      #
      def record_organism_for(infectable:, organism_name:)
        code = Renalware::PD::OrganismCode.find_by!(name: organism_name)

        infectable.infection_organisms.create!(organism_code: code)
      end

      def revise_organism_for(infectable:, sensitivity:, resistance:)
        organism = infectable.infection_organisms.last!

        organism.update!(sensitivity: sensitivity)
        organism.update!(resistance: resistance)
      end

      def terminate_organism_for(infectable:, user:)
        organism = infectable.infection_organisms.last!

        organism.destroy

        expect(infectable.infection_organisms).to be_empty
      end
    end

    module Web
      include Domain

      # @ section commands
      #
      def record_organism_for(infectable:, organism_name:)
        click_link "Add Infection Organism"
        wait_for_ajax

        within "#new_pd_infection_organism" do
          select(organism_name, from: "Organism")
          click_on "Save"
          wait_for_ajax
        end
      end

      def revise_organism_for(infectable:, sensitivity:, resistance:)
        within "#infection-organisms" do
          click_on "Edit"
          sleep 0.5
          expect(page).to have_selector("#infection-organisms form", count: 1)
          fill_in "Sensitivity", with: sensitivity
          fill_in "Resistance", with: resistance

          click_on "Save"
          expect(page).to have_no_css("form")

          expect(page).to have_selector("#infection-organisms tbody tr", count: 1)
          expect(find("tbody")).to have_content(sensitivity)
          expect(find("tbody")).to have_content(resistance)
        end
      end

      def terminate_organism_for(infectable:, user:)
        within "#infection-organisms" do
          click_on "Terminate"
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_no_css("tbody tr")
        end

        expect(infectable.infection_organisms).to be_empty
      end
    end
  end
end
