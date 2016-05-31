require "rails_helper"

module Renalware
  module Patients
    describe Language do
      it { is_expected.to validate_presence_of :name }
    end
  end
end
