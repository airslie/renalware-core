class CreateFnToArchiveMasterSlots < ActiveRecord::Migration[5.2]
  def up
    load_function("hd_diary_archive_elapsed_master_slots_v01.sql")
  end

  def down
    connection.execute("DROP FUNCTION IF EXISTS hd_diary_archive_elapsed_master_slots();")
  end
end
