module World
  module PD::InfectionOrganism
    module Domain
      # @ section commands
      #
      def record_organism_for(infectable:, organism_name:)
        code = Renalware::OrganismCode.find_by!(name: organism_name)

        infectable.infection_organisms.create!(organism_code: code)
      end

      def revise_organism_for(infectable:, sensitivity:)
        organism = infectable.infection_organisms.last!

        organism.update!(sensitivity: sensitivity)
      end
    end

    module Web
      include Domain

      # @ section commands
      #
      def record_organism_for(infectable:, organism_name:)
        click_link "Add Infection Organism"
        wait_for_ajax

        within "#new_infection_organism" do
          select(organism_name, from: "Organism")
          click_on "Save"
          wait_for_ajax
        end
      end

      def revise_organism_for(infectable:, sensitivity:)
        within "#infection-organisms" do
          click_on "Edit"
        end

        fill_in "Sensitivity", with: sensitivity
        click_on "Save"
        wait_for_ajax
      end
    end
  end
end
