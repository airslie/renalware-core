require 'rails_helper'

module Renalware
  module Letters
    describe ClinicLetter, type: :model do
      subject { create(:clinic_letter) }

      it { should validate_presence_of :clinic_visit_id }

      describe 'title' do
        it 'titleizes the class name' do
          expect(subject.title).to eq('Clinic Letter')
        end
      end
    end
  end
end