module World
  module PD::Medication
    module Domain
      # @ section commands
      #
      def record_medication_for(treatable:, drug_name:, dose:,
                               route_name:, frequency:, starts_on:, provider:)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        route = Renalware::MedicationRoute.find_by!(name: route_name)

        treatable.medications.create!(
          patient: treatable.patient,
          drug: drug,
          dose: dose,
          medication_route: route,
          frequency: frequency,
          start_date: starts_on,
          provider: provider.downcase
        )
      end
    end

    module Web
      include Domain

      # @ section commands
      #
      def record_medication_for(treatable:, drug_name:, dose:, route_name:,
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
          wait_for_ajax
        end
      end
    end
  end
end
