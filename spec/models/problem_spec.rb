require 'rails_helper'

RSpec.describe Problem, :type => :model do
  it { should belong_to :patient }
end
