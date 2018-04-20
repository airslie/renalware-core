# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe LetterPolicy, type: :policy do
    subject(:policy) { described_class }
    let(:super_admin_user) { user_with_role(:super_admin) }
    let(:admin_user) { user_with_role(:admin) }
    let(:clinical_user) { user_with_role(:clinical) }
    let(:read_only_user) { user_with_role(:read_only) }

    def user_with_role(role)
      instance_double(Renalware::User).tap do |user|
        allow(user).to receive(:has_role?).and_return(false)
        allow(user).to receive(:has_role?).with(role).and_return(true)
      end
    end

    permissions :author? do
      it { is_expected.to permit(super_admin_user) }
      it { is_expected.to permit(admin_user) }
      it { is_expected.to permit(clinical_user) }
      it { is_expected.not_to permit(read_only_user) }
    end

    permissions :destroy? do
      %i(Draft PendingReview).each do |letter_klass|
        context "when the letter is #{letter_klass}" do
          let(:letter) { "Renalware::Letters::Letter::#{letter_klass}".constantize.new }
          context "when the user is the author" do
            let(:user) { clinical_user }
            before { allow(letter).to receive(:author).and_return(user) }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is the creator" do
            let(:user) { clinical_user }
            before { allow(letter).to receive(:created_by).and_return(user) }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is a admin" do
            let(:user) { admin_user }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is a super admin" do
            let(:user) { super_admin_user }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is a clinical_user and not the creator or author" do
            let(:user) { clinical_user }

            it { is_expected.not_to permit(user, letter) }
          end

          context "when the user is read-only" do
            let(:user) { read_only_user }

            it { is_expected.not_to permit(user, letter) }
          end
        end
      end

      # In these states the letter should definitely not be destroyable even say if the
      # user is a super admin or author.
      %i(Approved Completed).each do |letter_klass|
        context "when the letter is #{letter_klass}" do
          let(:letter) { "Renalware::Letters::Letter::#{letter_klass}".constantize.new }

          context "when the user is a superadmin" do
            let(:user) { super_admin_user }

            it { is_expected.not_to permit(user, letter) }
          end

          context "when the user is the author" do
            let(:user) { clinical_user }
            before { allow(letter).to receive(:author).and_return(user) }

            it { is_expected.not_to permit(user, letter) }
          end
        end
      end
    end
  end
end
