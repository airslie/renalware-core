require "rails_helper"

module Renalware
  RSpec.describe Reporting::Audit, type: :model do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :view_name }
  end
end
