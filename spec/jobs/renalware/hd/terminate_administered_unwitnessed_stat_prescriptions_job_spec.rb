module Renalware
  module HD
    describe TerminateAdministeredUnwitnessedStatPrescriptionsJob do
      let(:pwd) { "password" }
      let(:user1) { create(:user, password: pwd) }
      let(:user2) { create(:user, password: pwd) }

      before do
        create(:user, :system)
        allow(Renalware.config)
          .to receive(:hd_session_prescriptions_require_signoff)
          .and_return(true)
      end

      describe "#perform" do
        def prescription_administration(witnessed:, administered:, fixed_number_of_doses:)
          prescription = create(:prescription, administer_on_hd: true)
          pa = new_prescription_administration(prescription, administered, user1, pwd)
          if witnessed
            pa.witnessed_by = user2
            pa.witnessed_by_password = pwd
          else
            pa.skip_witness_validation = true
          end
          pa.save!
          prescription.update_column(:fixed_number_of_doses, fixed_number_of_doses)

          expect(prescription.reload.termination.present?).to be(false)
          pa
        end

        def new_prescription_administration(prescription, administered, administered_by, pwd)
          PrescriptionAdministration.new(
            prescription:,
            administered:,
            administered_by:,
            administered_by_password: pwd,
            recorded_on: Time.zone.now,
            by: administered_by
          )
        end

        it "terminates administered one-dose HD prescriptions that are sitting around unstopped" do
          witnessed_administered_one_dose_pa = prescription_administration(
            witnessed: true,
            administered: true,
            fixed_number_of_doses: 1
          ) # prescription already terminated
          witnessed_administered_one_dose_pa.prescription.build_termination(
            terminated_on: Time.zone.today,
            by: user1
          ).save!

          unwitnessed_administered_one_dose_pa = prescription_administration(
            witnessed: false,
            administered: true,
            fixed_number_of_doses: 1
          )
          unwitnessed_unadministered_one_dose_pa = prescription_administration(
            witnessed: false,
            administered: false,
            fixed_number_of_doses: 1
          )
          unwitnessed_administered_unlimited_dose_pa = prescription_administration(
            witnessed: false,
            administered: true,
            fixed_number_of_doses: nil
          )

          # sanity checks!
          expect(witnessed_administered_one_dose_pa.prescription.termination).to be_present
          expect(unwitnessed_administered_one_dose_pa.prescription.termination).to be_nil
          expect(unwitnessed_unadministered_one_dose_pa.prescription.termination).to be_nil
          expect(unwitnessed_administered_unlimited_dose_pa.prescription.termination).to be_nil

          # When we run the job, it should only terminate prescriptions for
          # hd prescription administrations where
          # - it is administered
          # - the prescription is not already terminated
          # - the prescription is marked as give on hd with one fixed dose

          # So.. we are going to terminate the prescriptions for
          #  unwitnessed_administered_one_dose_pa
          # only!

          described_class.perform_now

          expect(unwitnessed_administered_one_dose_pa.prescription.reload.termination).to be_present

          # Sanity checks that these have not changed
          expect(witnessed_administered_one_dose_pa.prescription.reload.termination).to be_present
          expect(unwitnessed_unadministered_one_dose_pa.prescription.reload.termination).to be_nil
          expect(
            unwitnessed_administered_unlimited_dose_pa.prescription.reload.termination
          ).to be_nil
        end
      end
    end
  end
end
