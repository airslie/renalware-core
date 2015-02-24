class CreateExitSiteInfections < ActiveRecord::Migration
  def change
    create_table :exit_site_infections do |t|

      t.timestamps null: false
    end
  end
end
