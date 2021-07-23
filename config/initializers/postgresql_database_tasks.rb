# frozen_string_literal: true

module ActiveRecordPGTasks
  def drop
    establish_master_connection
    connection.select_all <<-SQL.squish
      SELECT pg_terminate_backend(pg_stat_activity.pid)
      FROM pg_stat_activity
      WHERE datname='#{configuration['database']}' AND state='idle';
    SQL
    connection.drop_database configuration["database"]
  end
end

ActiveRecord::Tasks::PostgreSQLDatabaseTasks.prepend(ActiveRecordPGTasks)
