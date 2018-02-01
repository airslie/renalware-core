class EnableCrosstabExtension < ActiveRecord::Migration[5.1]
  def up
    connection.execute("CREATE extension IF NOT EXISTS tablefunc;")
  end

  def down
    connection.execute("DROP extension IF EXISTS tablefunc;")
  end
end
