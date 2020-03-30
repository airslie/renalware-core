class CreatePathologyChartDataFunction < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("pathology_chart_data_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION IF EXISTS pathology_chart_data(integer, text, date);")
    end
  end
end
