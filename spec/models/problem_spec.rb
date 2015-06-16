require 'rails_helper'

describe Problem, :type => :model do
  it { should belong_to :patient }
end
