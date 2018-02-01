class MakeObsSetTriggerChangeUpdatedAt < ActiveRecord::Migration[5.1]
  def up
    load_function("update_current_observation_set_from_trigger_v02.sql")
  end

  def down
    load_function("update_current_observation_set_from_trigger_v01.sql")
  end
end
