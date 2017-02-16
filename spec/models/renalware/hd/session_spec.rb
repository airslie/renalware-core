require "rails_helper"

module Renalware
  module HD
    RSpec.describe Session, type: :model do
      it { is_expected.to have_many(:prescription_administrations) }
    end
  end
end
