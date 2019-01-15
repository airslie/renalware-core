# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe ClosedSessionPolicy, type: :policy do
      subject(:policy) { described_class }

      let(:user) { User.new }
      let(:session) { HD::Session::Closed.new }

      %i(edit? destroy?).each do |permission|
        permissions permission do
          it "not permitted if the session is ye saved" do
            allow(session).to receive(:persisted?).and_return(false)

            expect(policy).not_to permit(user, session)
          end
          it "permitted if the session is not yet immutable" do
            allow(session).to receive(:persisted?).and_return(true)
            allow(session).to receive(:immutable?).and_return(false)

            expect(policy).to permit(user, session)
          end
          it "not permitted if the session is immutable" do
            allow(session).to receive(:persisted?).and_return(true)
            allow(session).to receive(:immutable?).and_return(true)

            expect(policy).not_to permit(user, session)
          end
        end
      end
    end
  end
end
