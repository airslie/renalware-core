require "rails_helper"

module Renalware
  module HD
    describe DNASessionPolicy, type: :policy do
      subject { described_class }
      let(:user) { FactoryGirl.build(:user, :super_admin) }
      let(:session) { HD::Session::DNA.new }

      [:edit?, :destroy?].each do |permission|
        permissions permission do
          it "not permitted if unsaved" do
            expect(subject).to_not permit(user, session)
          end
          it "permitted if the session is not yet immutable" do
            allow(session).to receive(:persisted?).and_return(true)
            allow(session).to receive(:immutable?).and_return(false)
            expect(subject).to permit(user, session)
          end
          it "not permitted if the session is immutable" do
            allow(session).to receive(:persisted?).and_return(true)
            allow(session).to receive(:immutable?).and_return(true)
            expect(subject).to_not permit(user, session)
          end
        end
      end
    end
  end
end
