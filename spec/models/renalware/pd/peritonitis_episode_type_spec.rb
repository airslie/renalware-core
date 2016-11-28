require "rails_helper"

module Renalware
  module PD
    describe PeritonitisEpisodeType do
      it { is_expected.to belong_to(:peritonitis_episode_type_description) }
      it { is_expected.to belong_to(:peritonitis_episode) }
    end
  end
end
