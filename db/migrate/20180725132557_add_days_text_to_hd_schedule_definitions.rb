class AddDaysTextToHDScheduleDefinitions < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_schedule_definitions, :days_text, :text

    reversible do |direction|
      direction.up do
        sql = <<-SQL
        update hd_schedule_definitions set days_text = 'Mon Wed Fri' where days::text = '{1,3,5}';
        update hd_schedule_definitions set days_text = 'Tue Thu Sat' where days::text = '{2,4,6}';
        SQL
        connection.execute(sql)
      end
    end
  end
end
