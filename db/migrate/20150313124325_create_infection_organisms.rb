class CreateInfectionOrganisms < ActiveRecord::Migration
  def change
    create_table :infection_organisms do |t|

      t.timestamps null: false
    end
  end
end
