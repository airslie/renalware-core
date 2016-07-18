class AddIndexForTerminatedOnToPrescriptions < ActiveRecord::Migration
  def change
    add_index :prescriptions, :terminated_on
  end
end
