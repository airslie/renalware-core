class CreateCountEstimateFunction < ActiveRecord::Migration[5.1]
  def up
    load_function "count_estimate_v01.sql"
  end

  def down
    connection.execute("DROP FUNCTION count_estimate(text);")
  end
end
