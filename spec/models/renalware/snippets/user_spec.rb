require "rails_helper"

module Renalware
  RSpec.describe Snippets::User, type: :model do
    describe "validation" do
      it { is_expected.to have_many(:snippets) }
    end
  end
end
