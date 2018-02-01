class CreateFnToRefreshCurrentObs < ActiveRecord::Migration[5.1]
  def up
    load_function("refresh_current_observation_set_v01.sql")
  end

  def down
    connection.execute("drop function if exists refresh_current_observation_set(integer)")
  end
end
