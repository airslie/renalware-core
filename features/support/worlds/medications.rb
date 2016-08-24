module World
  module Medications
    module Domain
      include Renalware::PrescriptionsHelper

      # @section helpers
      #
      def default_medication_drug_selector; end

      def parse_date_string(time_string)
        return nil unless time_string.present?

        Date.parse(time_string)
      end

      # @section seeds
      #
      def seed_prescription_for(
        patient:, treatable: nil, drug_name:, dose_amount:,
        dose_unit:, route_code:, frequency:, prescribed_on:, provider:,
        terminated_on:, user: nil, **_
      )
        drug = Renalware::Drugs::Drug.find_or_create_by!(name: drug_name)
        route = Renalware::Medications::MedicationRoute.find_by!(code: route_code)

        user ||= Renalware::SystemUser.find

        prescription = patient.prescriptions.build(
          treatable: treatable || patient,
          drug: drug,
          dose_amount: dose_amount,
          dose_unit: dose_unit,
          medication_route: route,
          frequency: frequency,
          prescribed_on: prescribed_on,
          provider: provider.downcase,
          by: user
        )

        if (terminated_on = parse_date_string(terminated_on))
          prescription.build_termination(by: user, terminated_on: terminated_on)
        end

        prescription.save!
        prescription
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
        seed_prescription_for(args.reverse_merge(terminated_on: nil))
      end

      def record_prescription_for_patient(**args)
        record_prescription_for(args)
      end

      def revise_prescription_for(prescription:, patient:, user:, drug_selector: default_medication_drug_selector,
        prescription_params: {})
        update_params = { by: Renalware::SystemUser.find }
        prescription_params.each do |key, value|
          case key.to_sym
            when :drug_name
              drug = Renalware::Drugs::Drug.find_by!(name: value)
              update_params.merge!(drug: drug)
            when :dose
              dose_amount, dose_unit = value.split(" ")
              update_params.merge!(dose_amount: dose_amount, dose_unit: dose_unit)
            when :route_code
              route = Renalware::Medications::MedicationRoute.find_by!(code: value)
              update_params.merge!(medication_route: route)
            else
              update_params.merge!(key.to_sym => value)
          end
        end

        Renalware::Medications::RevisePrescription.new(prescription).call(update_params)
      end

      def terminate_prescription_for(patient:, user:, terminated_on: Date.current)
        prescription = patient.prescriptions.last!

        prescription.terminate(by: user, terminated_on: terminated_on).save
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
        expect(actual_prescriptions.size).to eq(expected_prescriptions.size)

        actual_prescriptions.zip(expected_prescriptions).each do |actual, expected|
          prescription = Renalware::Medications::PrescriptionPresenter.new(actual)
          expect(actual.drug.name).to eq(expected["drug_name"])
          expect(prescription.dose).to eq(expected["dose"])
          expect(actual.frequency).to eq(expected["frequency"])
          expect(actual.medication_route.code).to eq(expected["route_code"])
          expect(actual.provider.downcase).to eq(expected["provider"].downcase)
          expect(actual.terminated_on).to eq(parse_date_string(expected["terminated_on"]))
        end
      end

      def expect_patient_to_have_prescriptions(patient, prescriptions)
        expect(patient.prescriptions.count).to eq(prescriptions.count)

        prescriptions.each do |prescription_attributes|
          drug = Renalware::Drugs::Drug.find_by(
            name: prescription_attributes[:drug_name]
          )
          medication_route = Renalware::Medications::MedicationRoute.find_by(
            code: prescription_attributes[:route_code]
          )
          dose_amount, dose_unit = prescription_attributes[:dose].split(" ")

          prescription_exists = Renalware::Medications::Prescription.exists?(
            patient: patient,
            drug: drug,
            dose_amount: dose_amount,
            dose_unit: dose_unit,
            medication_route: medication_route,
            frequency: prescription_attributes[:frequency]
          )

          expect(prescription_exists).to be_truthy
        end
      end

      def expect_prescription_to_be_terminated_by(user, patient:)
        prescription = patient.prescriptions.last!

        expect(prescription).to be_terminated
        expect(prescription.terminated_by).to eq(user)
      end

      def expect_termination_to_be_rejected(patient)
        prescription = patient.prescriptions.last!

        expect(prescription).not_to be_terminated
      end

      def expect_prescription_revision_to_be_rejected(prescription)
        expect(prescription.valid?).to be_falsey
        expect(prescription.errors.empty?).to be_falsey
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

      def fill_in_dose(dose_amount, dose_unit)
        dose_unit = ::I18n.t(
          dose_unit, scope: "enumerize.renalware.medications.prescription.dose_unit"
        )
        fill_in "Dose amount", with: dose_amount
        select dose_unit, from: "Dose unit"
      end

      # @ section commands
      #
      def record_prescription_for(patient:, treatable: nil, drug_name:, dose_amount:,
        dose_unit:, route_code:, frequency:, prescribed_on:, provider:, terminated_on: "",
        drug_selector: default_medication_drug_selector)

        click_link "Add Prescription"
        wait_for_ajax

        within "#new_medications_prescription" do
          drug_selector.call(drug_name)
          fill_in_dose(dose_amount, dose_unit)
          select route_code, from: "Medication route"
          fill_in "Frequency", with: frequency
          fill_in "Prescribed on", with: prescribed_on
          fill_in "Terminated on", with: terminated_on
          click_on "Save"
          wait_for_ajax
        end
      end

      def record_prescription_for_patient(user:, patient:, **args)
        login_as user

        visit patient_prescriptions_path(patient)

        record_prescription_for(patient: patient, **args)
      end

      def revise_prescription_for(patient:, user:, drug_selector: default_medication_drug_selector,
        prescription_params: {})
        login_as user

        visit patient_prescriptions_path(patient)

        within "#current-prescriptions" do
          click_on "Edit"
        end

        within "#prescriptions" do
          prescription_params.each do |key, value|
            case key.to_sym
              when :drug_name
                drug_selector.call(value)
              when :dose
                dose_amount, dose_unit = value.split(" ")
                fill_in_dose(dose_amount, dose_unit)
              when :frequency
                fill_in "Frequency", with: value
              when :route_code
                select value, from: "Medication route"
            end
          end
          click_on "Save"
          wait_for_ajax
        end
      end

      def terminate_prescription_for(patient:, user:, terminated_on: Date.current)
        login_as user

        visit patient_prescriptions_path(patient)

        within "#current-prescriptions" do
          click_on "Terminate"
          wait_for_ajax
        end

        fill_in "Terminated on", with: I18n.l(terminated_on)
        fill_in "Notes", with: "This is completed."
        click_on "Save"
        wait_for_ajax
      end

      def view_prescriptions_for(clinician, patient)
        login_as clinician

        visit patient_prescriptions_path(patient)

        current_prescriptions = html_table_to_array("current-prescriptions").drop(1)
        historical_prescriptions = html_table_to_array("historical-prescriptions").drop(1)

        [current_prescriptions, historical_prescriptions]
      end

      # @ section expectations
      #
      def expect_current_prescriptions_to_match(actual_prescriptions, expected_prescriptions)
        actual_prescriptions.zip(expected_prescriptions).each do |actual, expected|
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
