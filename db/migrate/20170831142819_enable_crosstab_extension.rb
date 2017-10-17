class EnableCrosstabExtension < ActiveRecord::Migration[5.1]
  def up
    ActiveRecord::Base.connection.execute("CREATE extension IF NOT EXISTS tablefunc;")
  end

  def down
    ActiveRecord::Base.connection.execute("DROP extension IF EXISTS tablefunc;")
  end
end
