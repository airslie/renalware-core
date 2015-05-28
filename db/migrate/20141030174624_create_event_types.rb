class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|

      t.timestamps
    end
  end
end
