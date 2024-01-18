class CreateTransplantInvestigationTypes < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_table :transplant_investigation_types do |t|
        t.string :code, null: false
        t.string :description, null: false
        t.datetime :deleted_at, index: true
        t.timestamps null: false
        t.index :code, where: "deleted_at is null", unique: true
      end
    end
  end
end
