class AddPracticeToPatients < ActiveRecord::Migration[4.2]
  def change
    add_belongs_to :patients, :practice
  end
end
