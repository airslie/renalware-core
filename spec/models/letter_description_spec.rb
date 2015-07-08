require 'rails_helper'

describe LetterDescription, type: :model do
  it { should validate_presence_of :text }
  it { should have_many :letters }
end
