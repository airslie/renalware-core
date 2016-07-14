module World
  module Medications
    module Domain
      # @section helpers
      #
      def default_medication_drug_selector; end

      def parse_time_string(time_string)
        return nil unless time_string.present?

        Time.parse(time_string)
      end

      def seed_medication_for(patient:, treatable: nil, drug_name:, dose:,
        route_code:, frequency:, starts_on:, provider:, deleted_at:, **_)
        drug = Renalware::Drugs::Drug.find_or_create_by!(name: drug_name)
        route = Renalware::MedicationRoute.find_by!(code: route_code)

        medication_params = {
          treatable: treatable || patient,
          drug: drug,
          dose: dose,
          medication_route: route,
          frequency: frequency,
          start_date: starts_on,
          provider: provider.downcase,
          by: Renalware::SystemUser.find
        }

        if deleted_at.present?
          medication_params[:deleted_at] = parse_time_string(deleted_at)
        end

        patient.medications.create!(medication_params)
      end

      # @ section commands
      #
      def view_medications_for(_clinician, patient)
        current_medications =
          ::Renalware::Medications::TreatableMedicationsQuery
          .new(treatable: patient)
          .call
          .includes(:drug)

        terminated_medications =
          ::Renalware::Medications::TreatableTerminatedMedicationsQuery
          .new(treatable: patient)
          .call
          .includes(:drug)

        [current_medications, terminated_medications]
      end

      def record_medication_for(**args)
        seed_medication_for(args.merge(deleted_at: nil))
      end

      def record_medication_for_patient(user:, **args)
        record_medication_for(args)
      end

      def revise_medication_for(patient:, user:, drug_name:,
        drug_selector: default_medication_drug_selector)

        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        medication = patient.medications.last!

        medication.update!(drug: drug, by: Renalware::SystemUser.find)
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

      def expect_current_medications_to_match(actual_medications, expected_medications)
        actual_medications.zip(expected_medications).each do |actual, expected|
          expect(actual.drug.name).to eq(expected["drug_name"])
          expect(actual.dose).to eq(expected["dose"])
          expect(actual.frequency).to eq(expected["frequency"])
          expect(actual.medication_route.code).to eq(expected["route_code"])
          expect(actual.provider).to eq(expected["provider"].downcase)
          expect(actual.deleted_at).to eq(parse_time_string(expected["terminated_on"]))
        end
      end
    end

    module Web
      include Domain

      # @section helpers
      #
      def default_medication_drug_selector
        -> (drug_name, drug_type="Antibiotic") do
          select(drug_type, from: "Medication Type")
          select(drug_name, from: "Drug")
        end
      end

      # @ section commands
      #
      def record_medication_for(patient:, treatable: nil, drug_name:, dose:, route_code:,
        frequency:, starts_on:, provider:,
        drug_selector: default_medication_drug_selector)
        click_link "Add Medication"
        wait_for_ajax

        within "#new_medication" do
          drug_selector.call(drug_name)
          fill_in "Dose", with: dose
          select(route_code, from: "Route")
          fill_in "Frequency", with: frequency
          fill_in "Prescribed on", with: starts_on
          click_on "Save"
          wait_for_ajax
        end
      end

      def record_medication_for_patient(user:, patient:, **args)
        login_as user

        visit patient_medications_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        record_medication_for(patient: patient, **args.except(:deleted_at))
      end

      def revise_medication_for(patient:, user:, drug_name:,
        drug_selector: default_medication_drug_selector)

        login_as user

        visit patient_medications_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        within "#medications" do
          click_on "Edit"

          drug_selector.call(drug_name)
          click_on "Save"
          wait_for_ajax
        end
      end

      def terminate_medication_for(patient:, user:)
        login_as user

        visit patient_medications_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        within "#medications" do
          click_on "Terminate"
          wait_for_ajax
        end

        medication = patient.medications.with_deleted.last!

        expect(medication).to be_deleted
      end

      def view_medications_for(clinician, patient)
        login_as clinician

        visit patient_medications_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        current_medications = html_table_to_array("current_medications").drop(1)
        terminated_medications = html_table_to_array("terminated_medications").drop(1)

        [current_medications, terminated_medications]
      end

      def expect_current_medications_to_match(actual_medications, expected_medications)
        actual_medications.zip(expected_medications).each do |actual, expected|
          expected_route = Renalware::MedicationRoute.find_by!(code: expected[:route_code])

          expect(actual).to include(expected[:drug_name])
          expect(actual).to include(expected[:dose])
          expect(actual).to include(expected[:frequency])
          expect(actual).to include(expected_route.name)
          expect(actual).to include(expected[:provider])
        end
      end
    end
  end
end
