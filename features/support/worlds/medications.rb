module World
  module Medications
    module Domain
      # @ section commands
      #
      def record_medication_for(patient:, treatable: nil, drug_name:, dose:,
        route_name:, frequency:, starts_on:, provider:, **_)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        route = Renalware::MedicationRoute.find_by!(name: route_name)

        patient.medications.create!(
          treatable: treatable,
          drug: drug,
          dose: dose,
          medication_route: route,
          frequency: frequency,
          start_date: starts_on,
          provider: provider.downcase
        )
      end

      def record_medication_for_patient(user:, **args)
        record_medication_for(args)
      end

      def revise_medication_for(patient:, drug_name:)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        medication = patient.medications.last!

        medication.update!(drug: drug)
      end

      def terminate_medication_for(patient:, user:)
        medication = patient.medications.last!

        medication.destroy
        expect(medication).to be_deleted
      end

      def expect_medication_to_be_recorded(patient:)
        medication = patient.medications.last!

        expect(medication).to be_present
      end

      def expect_medication_to_be_revised(patient:)
        medication = patient.medications.last!

        expect(medication.created_at).not_to eq(medication.updated_at)
      end
    end

    module Web
      include Domain

      # @ section commands
      #
      def record_medication_for(patient:, treatable: nil, drug_name:, dose:, route_name:,
        frequency:, starts_on:, provider:,
        drug_selector: default_medication_drug_selector)

        click_link "Add Medication"
        wait_for_ajax

        within "#new_medication" do
          drug_selector.call(drug_name)
          fill_in "Dose", with: dose
          select(route_name, from: "Route")
          fill_in "Frequency", with: frequency
          fill_in "Prescribed on", with: starts_on
          click_on "Save"
          wait_for_ajax
        end
      end

      def record_medication_for_patient(patient:, user:, **args)
        login_as user

        visit patient_medications_path(patient, treatable_type: patient.class, treatable_id: patient.id)

        record_medication_for(patient: patient, **args)
      end

      def default_medication_drug_selector
        -> (drug_name, drug_type="Antibiotic") do
          select(drug_type, from: "Medication Type")
          select(drug_name, from: "Select Drug")
        end
      end

      def revise_medication_for(patient:, drug_name:)
        within "#medications" do
          click_on "Edit"

          select(drug_name, from: "Select Drug")
          click_on "Save"
          wait_for_ajax
        end
      end
    end

    def terminate_medication_for(patient:, user:)
      within "#medications" do
        click_on "Terminate"
        wait_for_ajax
      end

      medication = patient.medications.with_deleted.last!

      expect(medication).to be_deleted
    end
  end
end
