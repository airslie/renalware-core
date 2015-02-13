require 'rails_helper'

RSpec.describe PeritonitisEpisode, :type => :model do
  it { should belong_to :patient }
end
