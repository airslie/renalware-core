require 'rails_helper'

describe Address, type: :model do
  it { should validate_presence_of :street_1 }
  it { should validate_presence_of :postcode }
end
