# frozen_string_literal: true

require "rails_helper"

module Renalware::Patients
  describe PatientPolicy::Scope, type: :model do
    describe "#resolve" do
      subject(:resolved_scope) { described_class.new(user, default_scope).resolve }

      let(:default_scope)   { Renalware::Patient.order(:id) }
      let(:host_hospital)   { create(:hospital_centre, code: "A", host_site: true) }
      let(:other_hospital)  { create(:hospital_centre, code: "B", host_site: false) }
      let(:private_study)   { create(:research_study, private: true, by: user) }
      let(:public_study)    { create(:research_study, private: false, by: user) }

      def patient_at(hospital, in_study: nil)
        create(:patient, hospital_centre: hospital, by: user).tap do |patient|
          if in_study.present?
            create(:research_participation, patient: patient, study: in_study, by: user)
          end
        end
      end

      def create_user_with_role(role, at_hospital:)
        create(:user, role, hospital_centre: at_hospital)
      end

      def add_user_to_study(user, study)
        create(
          :research_investigatorship,
          user: user,
          study: study,
          created_by: user,
          updated_by: user
        )
      end

      context "when passed-in scope is nil" do
        let(:user) { create_user_with_role(:super_admin, at_hospital: host_hospital) }
        let(:default_scope) { nil }

        it { is_expected.to be_nil }
      end

      context "when the user is a super admin" do
        let(:user) { create_user_with_role(:super_admin, at_hospital: host_hospital) }
        let(:expected_patients) do
          [
            patient_at(host_hospital),
            patient_at(other_hospital),
            patient_at(host_hospital, in_study: private_study),
            patient_at(host_hospital, in_study: public_study),
            patient_at(other_hospital, in_study: private_study),
            patient_at(other_hospital, in_study: public_study)
          ]
        end

        it "can see all patients" do
          expect(resolved_scope).to eq(expected_patients.to_a)
        end
      end

      context "when a clinician works at the host site" do
        let(:user) { create_user_with_role(:clinical, at_hospital: host_hospital) }

        context "when they are not an investigator of the private study" do
          it "they can still see the private and public study particiants as long as they are "\
             "patients at the host hospital" do
            expected_patients = [
              patient_at(host_hospital, in_study: private_study),
              patient_at(host_hospital, in_study: public_study)
            ]
            patient_at(other_hospital, in_study: private_study)
            patient_at(other_hospital, in_study: public_study)

            expect(resolved_scope.to_a).to eq(expected_patients)
          end

          it "they cannot see patients at other hospitals" do
            expected_patients = [patient_at(host_hospital)]
            patient_at(other_hospital)

            expect(resolved_scope).to eq(expected_patients)
          end
        end

        context "when they ARE an investigator of the private study" do
          let(:user) { create_user_with_role(:clinical, at_hospital: host_hospital) }

          context "when there are no patients" do
            it "returns an empty array" do
              add_user_to_study(user, private_study)
              expect(resolved_scope).to eq([])
            end
          end

          it "they cannot see non-study patients at other hospitals" do
            add_user_to_study(user, private_study)
            expected_patients = [patient_at(host_hospital)]
            patient_at(other_hospital)

            expect(resolved_scope).to eq(expected_patients)
          end

          it "they cannot see deleted participations for patients from another hospital" do
            # ie the patient was removed from the study so they have a deleted_at datetime
            add_user_to_study(user, private_study)
            p1 = patient_at(host_hospital, in_study: private_study)
            p2 = patient_at(other_hospital, in_study: private_study)

            # Remove patient 2 from the study - will set deleted_at
            Renalware::Research::Participation.find_by(patient_id: p2.id).destroy!

            expect(resolved_scope.to_a).to eq([p1])
          end

          it "they cannot see participants from another hospital with a left_on date in the past" do
            # ie the patient was removed from the study so they have a deleted_at datetime
            add_user_to_study(user, private_study)
            p1 = patient_at(host_hospital, in_study: private_study)
            p2 = patient_at(other_hospital, in_study: private_study)

            p2_participant = Renalware::Research::Participation.find_by(patient_id: p2.id)
            p2_participant.update!(left_on: 1.week.ago)

            expect(resolved_scope.to_a).to eq([p1])
          end

          it "they can see study participants even if they are at another hospital" do
            add_user_to_study(user, private_study)
            expected_patients = [
              patient_at(host_hospital, in_study: private_study),
              patient_at(other_hospital, in_study: private_study)
            ]

            expect(resolved_scope.to_a).to eq(expected_patients)
          end
        end

        context "when they WERE an investigator of the private study but were removed" do
          let(:user) { create_user_with_role(:clinical, at_hospital: host_hospital) }

          it "they cannot see study participants at another hospital" do
            investigatorship = add_user_to_study(user, private_study)
            investigatorship.destroy! # soft deletes so wil get a deleted_at

            expected_patients = [
              patient_at(host_hospital, in_study: private_study)
            ]

            # They should not see this one as they are no longer a member of the study
            # and the user is at another hospital
            patient_at(other_hospital, in_study: private_study)

            expect(resolved_scope.to_a).to eq(expected_patients)
          end
        end

        context "when they are an investigator of the private study but the study was deleted" do
          let(:user) { create_user_with_role(:clinical, at_hospital: host_hospital) }

          it "they cannot see study participants at another hospital" do
            add_user_to_study(user, private_study)
            private_study.update_column(:deleted_at, 1.day.ago)

            expected_patients = [
              patient_at(host_hospital, in_study: private_study)
            ]

            # They should not see this one as the study is deleted
            patient_at(other_hospital, in_study: private_study)

            expect(resolved_scope.to_a).to eq(expected_patients)
          end
        end
      end
    end
  end
end
