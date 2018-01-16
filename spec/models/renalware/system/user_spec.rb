# rubocop:disable Metrics/ModuleLength
require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe User, type: :model do
    it_behaves_like "Personable"

    it { is_expected.to validate_presence_of(:given_name) }
    it { is_expected.to validate_presence_of(:family_name) }

    describe "validation" do
      describe "#professional_position" do
        it { is_expected.to validate_presence_of(:professional_position).on(:update) }

        context "when the user is resetting their password via devise passwords#edit" do
          subject{ described_class.new(reset_password_token: "123") }

          it { is_expected.not_to validate_presence_of(:professional_position).on(:update) }
        end

        context "when a super_admin user is updating" do
          subject{ described_class.new(skip_validation: true) }

          it { is_expected.not_to validate_presence_of(:professional_position).on(:update) }
        end
      end

      describe "#signature" do
        it { is_expected.to validate_presence_of(:signature).on(:update) }

        context "when the user is resetting their password via devise passwords#edit" do
          subject{ described_class.new(reset_password_token: "123") }

          it { is_expected.not_to validate_presence_of(:signature).on(:update) }
        end

        context "when a super_admin user is updating" do
          subject{ described_class.new(skip_validation: true) }

          it { is_expected.not_to validate_presence_of(:signature).on(:update) }
        end
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
