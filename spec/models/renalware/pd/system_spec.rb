require "rails_helper"

module Renalware
  module PD
    RSpec.describe System, type: :model do
      it { should validate_presence_of :name }
      it { should validate_presence_of :pd_type }
    end
  end
end
