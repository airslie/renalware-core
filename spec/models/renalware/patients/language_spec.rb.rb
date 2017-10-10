require "rails_helper"

module Renalware
  module Patients
    describe Language do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :code }
    end
  end
end
