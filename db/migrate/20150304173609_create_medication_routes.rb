class CreateMedicationRoutes < ActiveRecord::Migration
  def change
    create_table :medication_routes do |t|
      t.integer :administration_id, references: :administations
      t.references :administerable, polymorphic: true
    end
  end
end
