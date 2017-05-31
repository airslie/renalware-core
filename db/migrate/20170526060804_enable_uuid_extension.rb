class EnableUuidExtension < ActiveRecord::Migration[5.0]
  # Enable the pg extension that will allow us to have automatically
  # generated uuids in the format f8c9ffd6-a234-4729-bd2a-68379df315fb
  def change
    enable_extension 'uuid-ossp'
  end
end
