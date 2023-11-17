# frozen_string_literal: true

require "rails_helper"

describe "Create an HD prescription" do
  let(:patient) { create(:hd_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }
  let(:prescribed_on) { "2024-11-01" }
  let(:prescribed_on_date) { Date.parse(prescribed_on) }

  def prescription_params(administer_on_hd)
    {
      drug_id: create(:drug).id,
      treatable_id: patient.id,
      treatable_type: "Renalware::Patient",
      dose_amount: "10",
      medication_route_id: create(:medication_route).id,
      prescribed_on: prescribed_on,
      provider: "gp",
      unit_of_measure_id: create(:drug_unit_of_measure).id,
      frequency: :once_only,
      administer_on_hd: administer_on_hd
    }
  end

  describe "POST create" do
    context "when prescription is administer_on_hd" do
      it "additionally saves a termination with a future date of start_date + configured period" do
        period = 3.months
        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(period)

        params = prescription_params(true)
        post(
          patient_prescriptions_path(patient),
          params: { medications_prescription: params }
        )
        follow_redirect!

        expect(response).to be_successful

        prescription = Renalware::Medications::Prescription.last
        expect(prescription).to have_attributes(
          prescribed_on: prescribed_on_date,
          administer_on_hd: true
        )
        expect(prescription.termination).to have_attributes(
          terminated_on: prescribed_on_date + period,
          notes: "HD prescription scheduled to be terminated #{period.in_months} months from start"
        )
      end

      it "does not error when data is missing" do
        period = 3.months
        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(period)

        # Pass an invalid prescribed_on
        params = prescription_params(true).update(prescribed_on: "")

        expect {
          post(
            patient_prescriptions_path(patient),
            params: { medications_prescription: params }
          )
        }.not_to change(Renalware::Medications::Prescription, :count)

        expect(response).to be_successful # validation error, mno redirect
      end

      it "does not create a termination if the configured period is nil" do
        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(nil)

        params = prescription_params(true)

        post(
          patient_prescriptions_path(patient),
          params: { medications_prescription: params }
        )
        follow_redirect!
        expect(response).to be_successful

        expect(Renalware::Medications::Prescription.last.termination).to be_nil
      end
    end

    context "when administer_on_hd is false" do
      it "does not create a termination" do
        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(6.months)

        params = prescription_params(false)
        post(
          patient_prescriptions_path(patient),
          params: { medications_prescription: params }
        )
        follow_redirect!

        expect(response).to be_successful

        prescription = Renalware::Medications::Prescription.last
        expect(prescription).to have_attributes(administer_on_hd: false, termination: nil)
      end
    end
  end
end
