class AddStartedAtToHDSessions < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column :hd_sessions, :started_at, :datetime
      add_column :hd_sessions, :stopped_at, :datetime
      add_index :hd_sessions, [:started_at, :stopped_at]

      # In order to support overnight sessions, we are deprecating these 3 columns
      # - performed_on date
      # - start_time time
      # - end_time time
      # and replacing with these
      # - started_at datetime
      # - stopped_at datetime
      # So an HD session with these values
      # - performed_on "2021-12-12"
      # - start_tme "10:00:00"
      # - end_time "13:00:00"
      # becomes
      # - started_at "2021-12-13 10:00:00"
      # - stopped_at "2021-12-13 13:00:00"
      # and when a session is a DNA with not start_time we will use
      # "2021-12-12 00:00:00"
      connection.execute(<<-SQL.squish)
        UPDATE hd_sessions
        set started_at = (performed_on + coalesce(start_time, '00:00'::time))
        where performed_on is not null;
      SQL

      connection.execute(<<-SQL.squish)
        UPDATE hd_sessions
        set stopped_at = (performed_on + coalesce(end_time, '00:00'::time))
        where performed_on is not null and end_time is not null;
      SQL

      # Rename the 3 old columns as 'legacy'
      rename_column :hd_sessions, :performed_on, :performed_on_legacy
      rename_column :hd_sessions, :start_time, :start_time_legacy
      rename_column :hd_sessions, :end_time, :end_time_legacy

      # Allow nulls
      change_column_null :hd_sessions, :performed_on_legacy, true
    end
  end
end
