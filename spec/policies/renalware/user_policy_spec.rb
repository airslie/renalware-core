require 'rails_helper'

module Renalware

  describe UserPolicy, type: :policy do
    subject { UserPolicy.new(current_user, user) }

    let(:current_user) { build_stubbed :user }

    context "for a superadmin" do
      let(:user) { User.new }
      #TODO - tests permits
    end
  end

end