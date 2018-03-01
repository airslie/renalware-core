# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe DNASessionPolicy, type: :policy do
      subject(:policy) { described_class }

      let(:user) { FactoryBot.build(:user, :super_admin) }
      let(:session) { HD::Session::DNA.new }

      [:edit?, :destroy?].each do |permission|
        permissions permission do
          it "not permitted if unsaved" do
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
