require 'rails_helper'

RSpec.describe EsrfInfo, :type => :model do
  it { should belong_to :patient }
end
