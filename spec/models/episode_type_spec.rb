require 'rails_helper'

RSpec.describe EpisodeType, :type => :model do

  it { should have_many(:peritonitis_episode) }

end
