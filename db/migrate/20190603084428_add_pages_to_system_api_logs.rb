class AddPagesToSystemAPILogs < ActiveRecord::Migration[5.2]
  def change
    add_column :system_api_logs, :pages, :integer, null: false, default: 0
  end
end
