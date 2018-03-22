# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe User, type: :model do
    it_behaves_like "Personable"

    it { is_expected.to validate_presence_of(:given_name) }
    it { is_expected.to validate_presence_of(:family_name) }
    it { is_expected.to respond_to(:authentication_token) }

    describe "#generate_new_authentication_token" do
      it "creates a new token and saves it to the user" do
        user = create(:user)
        token = user.generate_new_authentication_token!
        expect(token.length).to be >= 20
        expect(user.reload.authentication_token).to eq(token)
      end
    end

    describe "validation" do
      it { is_expected.to validate_presence_of(:given_name) }
      it { is_expected.to validate_presence_of(:family_name) }

      context "when #with_extended_validation is true" do
        subject{ described_class.new(with_extended_validation: true) }

        it { is_expected.to validate_presence_of(:professional_position).on(:update) }
        it { is_expected.to validate_presence_of(:signature).on(:update) }
      end

      context "when #with_extended_validation is false" do
        subject{ described_class.new(with_extended_validation: false) }

        it { is_expected.not_to validate_presence_of(:professional_position).on(:update) }
        it { is_expected.not_to validate_presence_of(:signature).on(:update) }
      end
    end

    describe "class" do
      it "includes Deviseable to authenticate using Devise" do
        expect(User.ancestors).to include(Deviseable)
        arr = %i(expirable database_authenticatable rememberable registerable
                 validatable trackable timeoutable recoverable)
        expect(User.devise_modules).to match_array(arr)
      end
    end

    it "is unapproved by default" do
      expect(build(:user, :unapproved)).not_to be_approved
    end

    describe "read_only?" do
      it "denotes a user with the read_only role" do
        expect(create(:user, :read_only)).to have_role(:read_only)
      end
    end

    describe "#professional_signature" do
      subject(:user) { User.new(given_name: "X", family_name: "Y") }

      context "when there is no professional_position" do
        context "when there is no signature" do
          it "returns the full name only" do
            expect(user.professional_signature).to eq "X Y"
          end
        end

        context "when there is a signature" do
          it "returns the signature only" do
            user.signature = "Dr X Y"
            expect(user.professional_signature).to eq "Dr X Y"
          end
        end
      end

      context "when there is a professional_position" do
        context "when there is no signature" do
          it "returns the signature and professional_position" do
            user.professional_position = "Consultant"
            expect(user.professional_signature).to eq "X Y (Consultant)"
          end
        end
        context "when there is a signature" do
          it "returns the signature and professional_position" do
            user.signature = "Dr X Y"
            user.professional_position = "Consultant"
            expect(user.professional_signature).to eq "Dr X Y (Consultant)"
          end
        end
      end
    end

    describe "scopes" do
      describe "unapproved" do
        it "retrieves unapproved users" do
          approved = create(:user)
          unapproved = create(:user, :unapproved)

          actual = User.unapproved
          expect(actual.size).to eq(1)
          expect(actual).to include(unapproved)
          expect(actual).not_to include(approved)
        end
      end
      describe "inactive" do
        it "retrieves inactive users" do
          active = create(:user, last_activity_at: 1.minute.ago)
          inactive = create(:user, last_activity_at: 90.days.ago)

          actual = User.inactive
          expect(actual.size).to eq(1)
          expect(actual).to include(inactive)
          expect(actual).not_to include(active)
        end
      end
      describe "author" do
        it "retrieves users with a signature" do
          author = create(:user, signature: "Dr D.O. Good")
          unsigned = create(:user, signature: nil)

          actual = User.author
          expect(actual).to include(author)
          expect(actual).not_to include(unsigned)
        end
      end
    end
  end
end
