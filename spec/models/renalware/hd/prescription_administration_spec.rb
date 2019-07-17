# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe PrescriptionAdministration, type: :model do
      let(:administered_by) { User.new }
      let(:witnessed_by) { User.new }
      let(:skip_validation) { false }
      let(:administrator_authorisation_token) { nil }
      let(:witness_authorisation_token) { nil }

      it_behaves_like "an Accountable model"
      it { is_expected.to belong_to(:prescription) }
      it { is_expected.to belong_to(:hd_session).touch(true) }
      it { is_expected.to belong_to(:reason) }
      it { is_expected.to validate_presence_of(:prescription) }

      context "when administered is false" do
        describe "validation errors" do
          subject(:errors) do
            PrescriptionAdministration.new(
              administered: false
            ).tap(&:valid?).errors
          end

          it "does not validate the presence of administered_by" do
            expect(errors[:administered_by]).to be_empty
          end

          it "does not validate the presence of witnessed_by" do
            expect(errors[:witnessed_by]).to be_empty
          end

          it "does not validate the presence of administrator_authorisation_token" do
            expect(errors[:administrator_authorisation_token]).to be_empty
          end

          it "does not validate the presence of witness_authorisation_token" do
            expect(errors[:witness_authorisation_token]).to be_empty
          end
        end
      end

      context "when skip_validation is false" do
        describe "validation errors" do
          subject(:errors) do
            PrescriptionAdministration.new(
              skip_validation: false
            ).tap(&:valid?).errors
          end

          it "does not validate the presence of administered_by" do
            expect(errors[:administered_by]).to be_empty
          end

          it "does not validate the presence of witnessed_by" do
            expect(errors[:witnessed_by]).to be_empty
          end

          it "does not validate the presence of administrator_authorisation_token" do
            expect(errors[:administrator_authorisation_token]).to be_empty
          end

          it "does not validate the presence of witness_authorisation_token" do
            expect(errors[:witness_authorisation_token]).to be_empty
          end
        end
      end

      describe "validation errors" do
        subject(:errors) do
          PrescriptionAdministration.new(
            administered: true,
            administered_by: administered_by,
            witnessed_by: witnessed_by,
            skip_validation: skip_validation,
            administrator_authorisation_token: administrator_authorisation_token,
            witness_authorisation_token: witness_authorisation_token
          ).tap(&:valid?).errors
        end

        {
          administered_by: :administrator,
          witnessed_by: :witness
        }.each do |user, user_prefix|
          token_name = :"#{user_prefix}_authorisation_token"
          error_key = :"#{user_prefix}_authorisation_token"

          describe "#{user_prefix}_authorisation_token" do
            context "when skip_validation is true" do
              let(:skip_validation) { true }

              it "does not validate the token" do
                expect(errors[error_key]).to be_empty
              end
            end

            context "when #{user} is missing" do
              let(:"#{user}") { nil }

              it "does not validate the token" do
                expect(errors[error_key]).to be_empty
              end
            end

            context "when no token is present" do
              let(:"#{token_name}") { nil }

              it "is not valid" do
                expect(errors[error_key]).to eq(["can't be blank"])
              end
            end

            context "when the token matches the users auth_token" do
              let(:"#{user}") { create(:user, password: "MontyDon") }
              let(:"#{token_name}") { public_send(user).auth_token }

              it "is valid" do
                expect(errors[error_key]).to be_empty
              end
            end

            context "when the token doesn't match the users auth_token" do
              let(:"#{user}") { create(:user, password: "MontyDon") }
              let(:"#{user_prefix}_authorisation_token") { "badtoken" }

              it "is not valid" do
                # Expected token is administered_by.auth_token e.g.
                # 66dfe23be214d4cceafd62e3caef3c2650ae975fdc50a4bcc1f47cdba0e8bcc8
                # but we are sinmulating the token from another user or a hacked token
                expect(errors[error_key]).to eq(["invalid token"])
              end
            end
          end
        end
      end
    end
  end
end
