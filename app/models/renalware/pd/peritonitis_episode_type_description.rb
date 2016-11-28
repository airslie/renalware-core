require_dependency "renalware/pd"

module Renalware
  module PD
    class PeritonitisEpisodeTypeDescription < ActiveRecord::Base
      has_many :peritonitis_episode_types,
                class_name: "PD::PeritonitisEpisodeType"
    end
  end
end
