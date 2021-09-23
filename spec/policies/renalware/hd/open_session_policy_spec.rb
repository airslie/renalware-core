# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe OpenSessionPolicy, type: :policy do
      include RolesSpecHelper
      subject(:policy) { described_class }

      let(:user) { user_with_role(:super_admin) }
      let(:session) { HD::Session::Closed.new }

      %i(edit? destroy?).each do |permission|
        permissions permission do
          it "no permitted if session unsaved" do
            expect(policy).not_to permit(user, session)
          end

          it "permitted if session saved" do
            allow(session).to receive(:persisted?).and_return(true)
            expect(policy).to permit(user, session)
          end
        end
      end
    end
  end
end
