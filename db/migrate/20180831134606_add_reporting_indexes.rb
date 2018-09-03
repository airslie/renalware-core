class AddReportingIndexes < ActiveRecord::Migration[5.1]
  def up
    connection.execute(<<-SQL)
      CREATE INDEX pathology_observations_created_on ON pathology_observations USING btree ((created_at::date));
    SQL
  end

  def down
    connection.execute(<<-SQL)
      DROP INDEX pathology_observations_created_on;
    SQL
  end
end
