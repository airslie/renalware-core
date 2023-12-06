class UpdatePathologyChartSeriesFn < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      load_function("pathology_chart_series_v02.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("pathology_chart_series_v01.sql")
    end
  end
end
