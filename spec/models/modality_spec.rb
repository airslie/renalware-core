require 'rails_helper'

describe Modality, :type => :model do
  it { should belong_to(:modality_code) }
  it { should belong_to(:patient) }
  it { should belong_to(:modality_reason) }
end
