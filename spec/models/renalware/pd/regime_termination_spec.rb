require "rails_helper"

module Renalware
  module PD
    RSpec.describe RegimeTermination do
      it_behaves_like "an Accountable model"
      it { is_expected.to validate_timeliness_of :terminated_on }
      it { is_expected.to belong_to(:regime).touch(true) }
    end
  end
end
