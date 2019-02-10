class AddSiteToPatient < ActiveRecord::Migration[5.2]
  def change
    add_reference :patients, :hospital_centre, index: true, foreign_key: true
  end
end
