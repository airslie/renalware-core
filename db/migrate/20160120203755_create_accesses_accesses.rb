class CreateAccessesAccesses < ActiveRecord::Migration
  def change
    create_table :access_accesses do |t|
      t.references :source, polymorphic: true, index: true, null: false
      t.references :description, null: false
      t.references :site, null: false
      t.string :side

      t.timestamps null: false
    end

    add_index :access_accesses, :description_id
    add_index :access_accesses, :site_id

    add_foreign_key :access_accesses, :access_descriptions, column: :description_id
    add_foreign_key :access_accesses, :access_sites, column: :site_id
  end
end
