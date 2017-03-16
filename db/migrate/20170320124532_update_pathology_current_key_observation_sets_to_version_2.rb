class UpdatePathologyCurrentKeyObservationSetsToVersion2 < ActiveRecord::Migration
  def change
    update_view :pathology_current_key_observation_sets, version: 2, revert_to_version: 1
  end
end
