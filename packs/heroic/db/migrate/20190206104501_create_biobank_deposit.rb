class CreateBiobankDeposit < ActiveRecord::Migration[5.2]
  def change
    reversible do |direction|
      direction.up { create_schema "renalware_heroic" }
      direction.down { drop_schema "renalware_heroic" }
    end

    within_renalware_schema(suffix: :heroic) do
      create_table :biobank_samples do |t|
        t.references :patient, null: false, index: true
        t.integer :study_visit_number, index: true
        t.string :sample_type, null: false, index: true # dna or rna or serum etc - from enum
        t.datetime :collected_at, index: true
        t.datetime :received_at, index: true
        t.datetime :removed_at, index: true
        t.datetime :processed_at
        t.string :storage_location
        t.text :notes
        t.string :removed_for_study
        t.integer :usable_count, default: 0, null: false
        t.integer :aliquots_count, default: 0, null: false
        t.datetime :deleted_at, index: true
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.timestamps null: false
      end

      # biobank_usage is polymorphic through biobank_aliquots.usages & biobank_samples.usages
      create_table :biobank_usages do |t|
        t.references :usable, polymorphic: true, index: true, null: false
        t.datetime :used_at, index: true, null: false
        t.string :study_name, null: false
        t.string :notes
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      create_table :biobank_aliquots do |t|
        t.references :sample, null: false, foreign_key: { to_table: :biobank_samples }, index: true
        t.integer :usable_count, default: 0, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      create_table :biobank_versions do |t|
        t.string   :item_type, null: false
        t.integer  :item_id,   null: false
        t.string   :event,     null: false
        t.integer  :whodunnit, index: true
        t.jsonb    :object
        t.jsonb    :object_changes
        t.datetime :created_at
      end
      add_index :biobank_versions, [:item_type, :item_id]
    end
  end
end
