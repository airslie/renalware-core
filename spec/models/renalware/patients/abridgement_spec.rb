# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    describe Abridgement do
      it { is_expected.to validate_presence_of(:hospital_number) }
      it { is_expected.to validate_presence_of(:given_name) }
      it { is_expected.to validate_presence_of(:family_name) }
    end
  end
end
