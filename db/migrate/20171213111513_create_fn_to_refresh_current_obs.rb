class CreateFnToRefreshCurrentObs < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function("refresh_current_observation_set_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("drop function if exists refresh_current_observation_set(integer)")
    end
  end
end
