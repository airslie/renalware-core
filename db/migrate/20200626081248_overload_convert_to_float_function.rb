class OverloadConvertToFloatFunction < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("convert_to_float_with_explicit_return_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION renalware.convert_to_float(text, float)")
    end
  end
end
