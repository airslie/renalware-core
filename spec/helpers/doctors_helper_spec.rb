require 'rails_helper'

describe DoctorsHelper, type: :helper do
  describe 'practices_options_for_select' do
    it 'returns Practices as html options' do
      p1 = create(:practice, name: 'AAA')
      p2 = create(:practice, name: 'BBB')
      p3 = create(:practice, name: 'CCC')
      doctor = build_stubbed(:doctor, practices: [p1,p3])
      actual = practices_options_for_select(doctor)

      expect(actual).to match('<option selected="selected" value="1">AAA</option>')
      expect(actual).to match('<option value="2">BBB</option>')
      expect(actual).to match('<option selected="selected" value="3">CCC</option>')
    end
  end
end
