class CreateTriggerToUpdateCurrentObservationSets < ActiveRecord::Migration[5.1]
  def up
    load_function("update_current_observation_set_from_trigger_v01.sql")
    load_trigger("update_current_observation_set_trigger_v01.sql")
  end

  def down
    connection.execute("
      DROP TRIGGER IF EXISTS update_current_observation_set_trigger ON pathology_observations;
      DROP FUNCTION IF EXISTS update_current_observation_set_from_trigger();
    ")
  end
end
