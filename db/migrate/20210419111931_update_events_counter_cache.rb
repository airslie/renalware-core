class UpdateEventsCounterCache < ActiveRecord::Migration[5.2]
  def change
    Renalware::Events::Type.reset_counters!
  end
end
