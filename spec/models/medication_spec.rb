require 'rails_helper'

RSpec.describe Medication, :type => :model do
  it { should belong_to(:patient) }
  it { should belong_to(:medicatable) }
  it { should belong_to(:treatable) }
  it { should belong_to(:medication_route) }

  it { should validate_presence_of :patient }

  it { should validate_presence_of(:medicatable_id).with_message("Medication to be administered can't be blank") }
  it { should validate_presence_of(:dose).with_message("Dose can't be blank") }
  it { should validate_presence_of(:medication_route_id).with_message("Route can't be blank") }
  it { should validate_presence_of(:frequency).with_message("Frequency & Duration can't be blank") }
  it { should validate_presence_of(:start_date).with_message("Prescribed On can't be blank") }
  it { should validate_presence_of(:provider).with_message("Provider can't be blank") }

  describe 'self.peritonitis' do
    it "should set 'treatable_type' as 'PeritonitisEpisode' for a medication relating to peritonitis" do
      expect(Medication.peritonitis.treatable_type).to eq('PeritonitisEpisode')
    end
  end

  describe 'self.exit_site' do
    it "should set 'treatable_type' as 'ExitSiteInfection' for a medication relating to exit site" do
      expect(Medication.exit_site.treatable_type).to eq('ExitSiteInfection')
    end
  end

end
