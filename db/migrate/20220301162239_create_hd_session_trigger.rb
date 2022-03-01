class CreateHDSessionTrigger < ActiveRecord::Migration[6.0]
  def up
    within_renalware_schema do
      load_function("update_hd_sessions_from_trigger_v01.sql")
      load_trigger("hd_sessions_trigger_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute(
        "DROP TRIGGER IF EXISTS update_hd_sessions_trigger ON renalware.hd_sessions; " \
        "drop function if exists renalware.update_hd_sessions_from_trigger();"
      )
    end
  end
end
