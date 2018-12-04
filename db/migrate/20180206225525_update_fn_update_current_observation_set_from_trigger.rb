class UpdateFnUpdateCurrentObservationSetFromTrigger < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function("update_current_observation_set_from_trigger_v03.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("update_current_observation_set_from_trigger_v02.sql")
    end
  end
end
