class UpdateUpdateCurrentObservationSetFromTriggerV06 < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      load_function("update_current_observation_set_from_trigger_v06.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("update_current_observation_set_from_trigger_v05.sql")
    end
  end
end
