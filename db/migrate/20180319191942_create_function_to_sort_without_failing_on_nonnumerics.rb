class CreateFunctionToSortWithoutFailingOnNonnumerics < ActiveRecord::Migration[5.1]
  def up
    load_function("convert_to_float_v01.sql")
  end

  def down
    connection.execute("drop function if exists convert_to_float(text)")
  end
end
