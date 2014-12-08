require 'rails_helper'

RSpec.describe Patient, :type => :model do
  it { should have_many :problems } 
  it { should accept_nested_attributes_for(:problems) } 
  # should accept_nested_attributes_for...
end
