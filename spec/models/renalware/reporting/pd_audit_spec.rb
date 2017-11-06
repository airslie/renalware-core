require "rails_helper"

module Renalware
  RSpec.describe "PD Audit", type: :model do
    include PatientsSpecHelper
    let(:user) { create(:user) }

    describe "json from reporting_pd_audit view" do
      describe ":data" do
        context "when are no rows" do
          pending
        end
      end
    end
  end
end
