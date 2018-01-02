class AddEsiFields < ActiveRecord::Migration[5.0]
  def change
    add_column :pd_exit_site_infections, :recurrent, :boolean, null: true
    add_column :pd_exit_site_infections, :cleared, :boolean, null: true
    add_column :pd_exit_site_infections, :catheter_removed, :boolean, null: true
    add_column :pd_exit_site_infections, :clinical_presentation, :string, array: true, null: true
    add_index :pd_exit_site_infections, :clinical_presentation, using: "gin"
  end
end
