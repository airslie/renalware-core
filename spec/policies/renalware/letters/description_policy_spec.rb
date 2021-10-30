# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe DescriptionPolicy, type: :policy do
      include PolicySpecHelper
      subject { described_class }

      let(:clinician) { user_double_with_role(:clinical) }
      let(:admin) { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:description) { instance_double(Description, deleted?: false) }

      [:show?, :index?].each do |permission|
        permissions permission do
          it "applies permission correctly", :aggregate_failures do
            is_expected.not_to permit(clinician, description)
            is_expected.to permit(admin, description)
            is_expected.to permit(super_admin, description)
          end
        end
      end

      context "when the description is not deleted" do
        [:new?, :create?, :edit?, :update?, :destroy?].each do |permission|
          permissions permission do
            it "applies permission correctly", :aggregate_failures do
              is_expected.not_to permit(clinician, description)
              is_expected.not_to permit(admin, description)
              is_expected.to permit(super_admin, description)
            end
          end
        end
      end

      context "when the description is deleted" do
        let(:description) { instance_double(Description, deleted?: true) }

        [:edit?, :destroy?].each do |permission|
          permissions permission do
            it "applies permission correctly", :aggregate_failures do
              is_expected.not_to permit(clinician, description)
              is_expected.not_to permit(admin, description)
              is_expected.not_to permit(super_admin, description)
            end
          end
        end
      end
    end
  end
end
