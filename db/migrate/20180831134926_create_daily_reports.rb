class CreateDailyReports < ActiveRecord::Migration[5.1]
  def change
    reversible do |direction|
      direction.up { connection.execute("SET SEARCH_PATH=renalware,public;") }
      direction.down { connection.execute("SET SEARCH_PATH=renalware,public;") }
    end

    create_view :reporting_daily_pathology
    create_view :reporting_daily_letters
  end
end
