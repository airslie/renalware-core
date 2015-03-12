require 'rails_helper'

RSpec.describe PatientProblem, :type => :model do
  it { should belong_to :patient }

end
