# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe LetterPolicy, type: :policy do
    subject(:policy) { described_class }
    let(:super_admin_user) { create(:user, :super_admin) }
    let(:admin_user) { create(:user, :admin) }
    let(:clinical_user) { create(:user, :clinical) }
    let(:read_only_user) { create(:user, :read_only) }

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
            before { letter.author = user }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is the creator" do
            let(:user) { clinical_user }
            before { letter.created_by = user }

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
            before { letter.author = user }

            it { is_expected.not_to permit(user, letter) }
          end
        end
      end
    end
  end
end
