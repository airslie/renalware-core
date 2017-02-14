class RenameEnterredOnToEnteredOn < ActiveRecord::Migration[4.2]
  def change
    rename_column :transplant_registrations, :enterred_on, :entered_on
  end
end
