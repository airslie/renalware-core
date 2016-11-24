class RenameEnterredOnToEnteredOn < ActiveRecord::Migration
  def change
    rename_column :transplant_registrations, :enterred_on, :entered_on
  end
end
