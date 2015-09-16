require 'rails_helper'
require './spec/support/login_macros'

module Renalware
  RSpec.describe Medication, :type => :model do
    it { should belong_to(:patient) }
    it { should belong_to(:medicatable) }
    it { should belong_to(:treatable) }
    it { should belong_to(:medication_route) }

    it { should validate_presence_of :patient }

    it { should validate_presence_of(:medicatable_id) }
    it { should validate_presence_of(:dose) }
    it { should validate_presence_of(:medication_route_id) }
    it { should validate_presence_of(:frequency) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:provider) }

    describe 'self.peritonitis' do
      it "should set 'treatable_type' as 'PeritonitisEpisode' for a medication relating to peritonitis" do
        expect(Medication.peritonitis.treatable_type).to eq('Renalware::PeritonitisEpisode')
      end
    end

    describe 'self.exit_site' do
      it "should set 'treatable_type' as 'ExitSiteInfection' for a medication relating to exit site" do
        expect(Medication.exit_site.treatable_type).to eq('Renalware::ExitSiteInfection')
      end
    end

  end
end