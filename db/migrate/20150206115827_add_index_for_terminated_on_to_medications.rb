class AddIndexForTerminatedOnToMedications < ActiveRecord::Migration
  def change
    add_index :medications, :terminated_on
  end
end
