require 'rails_helper'

module Renalware
  RSpec.describe InfectionOrganism, :type => :model do
    it { should belong_to(:organism_code) }
    it { should belong_to(:infectable) }

    it { should validate_uniqueness_of(:organism_code_id).scoped_to([:infectable_id, :infectable_type]) }
    it { should validate_presence_of(:organism_code_id) }

    describe 'organism validation custom error message', :type => :feature, :js => true do
      context 'peritonitis episode' do
        it 'should display custom error message when an infection organism fails validation' do
          @patient = create(:patient)
          login_as_clinician
          visit new_patient_peritonitis_episode_path(@patient)

          click_link 'Record a new organism and sensitivity'
          click_on 'Save Peritonitis Episode'

          expect(page).to have_content("Organism can't be blank")
        end
      end
    end

  end
end