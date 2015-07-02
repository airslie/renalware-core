class AddPracticeToPatients < ActiveRecord::Migration
  def change
    add_belongs_to :patients, :practice
  end
end
