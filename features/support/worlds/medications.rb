module World
  module Medications
    module Domain
      # @section helpers
      #
      def default_medication_drug_selector; end

      def parse_date_string(time_string)
        return nil unless time_string.present?

        Date.parse(time_string)
      end

      # @section seeds
      #
      def seed_prescription_for(patient:, treatable: nil, drug_name:, dose_amount:,
        dose_unit:, route_code:, frequency:, prescribed_on:, provider:, terminated_on:, **_)
        drug = Renalware::Drugs::Drug.find_or_create_by!(name: drug_name)
        route = Renalware::Medications::MedicationRoute.find_by!(code: route_code)

        patient.prescriptions.create!(
          treatable: treatable || patient,
          drug: drug,
          dose_amount: dose_amount,
          dose_unit: dose_unit,
          medication_route: route,
          frequency: frequency,
          prescribed_on: prescribed_on,
          provider: provider.downcase,
          terminated_on: parse_date_string(terminated_on),
          by: Renalware::SystemUser.find
        )
      end

      # @ section commands
      #
      def view_prescriptions_for(_clinician, patient)
        current_prescriptions =
          ::Renalware::Medications::PrescriptionsQuery
          .new(relation: patient.prescriptions.current)
          .call
          .includes(:drug)

        historical_prescriptions =
          ::Renalware::Medications::PrescriptionsQuery
          .new(relation: patient.prescriptions)
          .call
          .includes(:drug)

        [current_prescriptions, historical_prescriptions]
      end

      def record_prescription_for(**args)
        seed_prescription_for(args.merge(terminated_on: nil))
      end

      def record_prescription_for_patient(user:, **args)
        record_prescription_for(args)
      end

      def revise_prescription_for(patient:, user:, drug_selector: default_medication_drug_selector,
        prescription_params: {})
        prescription = patient.prescriptions.last!

        update_params = { by: Renalware::SystemUser.find }
        prescription_params.each do |key, value|
          case key
            when :drug_name
              drug = Renalware::Drugs::Drug.find_by!(name: value)
              update_params.merge!(drug: drug)
            else
              update_params.merge!(key.to_sym => value)
          end
        end

        Renalware::Medications::RevisePrescription.new(prescription).call(update_params)
      end

      def terminate_prescription_for(patient:, user:)
        prescription = patient.prescriptions.last!

        prescription.terminate(by: user).save!
        expect(prescription).to be_terminated
      end

      # @ section expectations
      #
      def expect_prescription_to_be_recorded(patient:)
        prescription = patient.prescriptions.last!

        expect(prescription).to be_present
      end

      def expect_prescription_to_be_revised(patient:)
        expect(patient.prescriptions.count).to eq(2)
      end

      def expect_current_prescriptions_to_match(actual_prescriptions, expected_prescriptions)
        actual_prescriptions.zip(expected_prescriptions).each do |actual, expected|
          prescription = Renalware::Medications::PrescriptionPresenter.new(actual)
          expect(actual.drug.name).to eq(expected["drug_name"])
          expect(prescription.dose).to eq(expected["dose"])
          expect(actual.frequency).to eq(expected["frequency"])
          expect(actual.medication_route.code).to eq(expected["route_code"])
          expect(actual.provider).to eq(expected["provider"].downcase)
          expect(actual.terminated_on).to eq(parse_date_string(expected["terminated_on"]))
        end
      end

      def expect_prescription_to_exist(patient, attributes)
        drug = Renalware::Drugs::Drug.find_by(name: attributes[:drug_name])
        medication_route = Renalware::Medications::MedicationRoute.find_by(
          code: attributes[:route_code]
        )

        prescription_exists = Renalware::Medications::Prescription.exists?(
          patient: patient,
          drug: drug,
          dose: attributes[:dose],
          medication_route: medication_route,
          frequency: attributes[:frequency],
          terminated_on: parse_date_string(attributes[:terminated_on])
        )

        expect(prescription_exists).to be_truthy
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
      def record_prescription_for(patient:, treatable: nil, drug_name:, dose_amount:,
        dose_unit:, route_code:, frequency:, prescribed_on:, provider:, terminated_on: nil,
        drug_selector: default_medication_drug_selector)
        click_link "Add Prescription"
        wait_for_ajax

        within "#new_medications_prescription" do
          dose_unit = ::I18n.t(
            dose_unit, scope: "enumerize.renalware.medications.prescription.dose_unit"
          )
          drug_selector.call(drug_name)
          fill_in "Dose amount", with: dose_amount
          select dose_unit, from: "Dose unit"
          select route_code, from: "Medication route"
          fill_in "Frequency", with: frequency
          fill_in "Prescribed on", with: prescribed_on
          click_on "Save"
          wait_for_ajax
        end
      end

      def record_prescription_for_patient(user:, patient:, **args)
        login_as user

        visit patient_prescriptions_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        record_prescription_for(patient: patient, **args.except(:terminated_on))
      end

      def revise_prescription_for(patient:, user:, drug_selector: default_medication_drug_selector,
        prescription_params: {})
        login_as user

        visit patient_prescriptions_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        within "#current-prescriptions" do
          click_on "Edit"
        end

        within "#prescriptions" do
          prescription_params.each do |key, value|
            case key.to_sym
              when :drug_name
                drug_selector.call(value)
              when :dose
                fill_in "Dose", with: value
            end
          end
          click_on "Save"
          wait_for_ajax
        end
      end

      def terminate_perscriptions_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        within "#current-perscriptions" do
          click_on "Terminate"
          wait_for_ajax
        end

        perscription = patient.perscriptions.last!

        expect(perscription).to be_terminated
      end

      def view_perscriptions_for(clinician, patient)
        login_as clinician

        visit patient_perscriptions_path(patient,
          treatable_type: patient.class, treatable_id: patient.id)

        current_perscriptions = html_table_to_array("current-perscriptions").drop(1)
        historical_perscriptions = html_table_to_array("historical-perscriptions").drop(1)

        [current_perscriptions, historical_perscriptions]
      end

      # @ section expectations
      #
      def expect_current_perscriptions_to_match(actual_perscriptions, expected_perscriptions)
        actual_perscriptions.zip(expected_perscriptions).each do |actual, expected|
          expected_route = Renalware::Medications::MedicationRoute.find_by!(code: expected[:route_code])

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
