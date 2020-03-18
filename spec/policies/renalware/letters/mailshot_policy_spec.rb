# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Mailshots
      describe MailshotPolicy, type: :policy do
        include PatientsSpecHelper
        subject { described_class }

        let(:clinician) { create(:user, :clinical) }
        let(:admin) { create(:user, :admin) }
        let(:super_admin) { create(:user, :super_admin) }
        let(:mailshot) { Mailshot.new }

        [:new?, :create?].each do |permission|
          permissions permission do
            it "applies permission correctly", :aggregate_failures do
              is_expected.not_to permit(clinician, mailshot)
              is_expected.not_to permit(admin, mailshot)
              is_expected.to permit(super_admin, mailshot)
            end
          end
        end

        [:index?].each do |permission|
          permissions permission do
            it "applies index permission correctly", :aggregate_failures do
              is_expected.not_to permit(clinician, mailshot)
              is_expected.to permit(admin, mailshot)
              is_expected.to permit(super_admin, mailshot)
            end
          end
        end
      end
    end
  end
end
