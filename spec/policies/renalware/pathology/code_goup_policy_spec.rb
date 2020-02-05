# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    describe CodeGroupPolicy, type: :policy do
      include PatientsSpecHelper
      subject { described_class }

      let(:code_group) do
        instance_double(
          Renalware::Pathology::CodeGroup
        )
      end

      let(:clinician) { create(:user, :clinical) }
      let(:admin) { create(:user, :admin) }
      let(:super_admin) { create(:user, :super_admin) }

      permissions :index? do
        it :aggregate_failures do
          is_expected.to permit(clinician, code_group)
          is_expected.to permit(admin, code_group)
          is_expected.to permit(super_admin, code_group)
        end
      end

      [:create?, :edit?, :update?, :destroy?].each do |permission|
        permissions permission do
          it :aggregate_failures do
            is_expected.not_to permit(clinician, code_group)
            is_expected.not_to permit(admin, code_group)
            is_expected.to permit(super_admin, code_group)
          end
        end
      end
    end
  end
end
