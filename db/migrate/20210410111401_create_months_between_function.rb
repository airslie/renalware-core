class CreateMonthsBetweenFunction < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("months_between_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION months_between(timestamp, timestamp)")
    end
  end
end
