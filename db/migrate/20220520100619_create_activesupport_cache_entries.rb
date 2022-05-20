class CreateActivesupportCacheEntries < ActiveRecord::Migration[6.0]
  def up
    within_renalware_schema do
      ActiveSupport::Cache::DatabaseStore::Migration.migrate(:up)
    end
  end

  def down
    within_renalware_schema do
      ActiveSupport::Cache::DatabaseStore::Migration.migrate(:down)
    end
  end
end
