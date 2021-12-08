class AddSiteToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :hospital_centre, index: true, foreign_key: true
  end
end
