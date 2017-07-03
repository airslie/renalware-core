require "rails_helper"

module Renalware
  RSpec.describe Reporting::Audit, type: :model do
    it { should validate_presence_of :name }
    it { should validate_presence_of :materialized_view_name }
    it { should validate_presence_of :refresh_schedule }
  end
end
