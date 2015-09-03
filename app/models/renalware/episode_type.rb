module Renalware
  class EpisodeType < ActiveRecord::Base

    has_many :peritonitis_episodes

  end
end