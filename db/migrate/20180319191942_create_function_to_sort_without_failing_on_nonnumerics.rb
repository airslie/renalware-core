class CreateFunctionToSortWithoutFailingOnNonnumerics < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function("convert_to_float_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("drop function if exists convert_to_float(text)")
    end
  end
end
