require 'rails_helper'

module Renalware
  describe LetterDescription, type: :model do
    it { should validate_presence_of :text }
    it { should have_many :letters }
  end
end