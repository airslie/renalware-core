class CreateDaysBetweenFunction < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("days_between_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION days_between(timestamp, timestamp)")
    end
  end
end
