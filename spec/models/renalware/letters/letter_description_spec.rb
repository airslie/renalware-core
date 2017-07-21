require "rails_helper"

module Renalware
  module Letters
    describe Description, type: :model do
      it { is_expected.to validate_presence_of :text }
    end
  end
end
