class CreateHDAnticoagulants < ActiveRecord::Migration[8.1]
  DEFAULT_ANTICOAGULANTS = {
    none: "None",
    heparin: "Heparin",
    enoxyparin: "Enoxaparin",
    warfarin: "Warfarin",
    tinzaparin: "Tinzaparin"
  }.freeze

  def up
    within_renalware_schema do
      create_table :hd_anticoagulants do |t|
        t.string :code, null: false
        t.string :name, null: false
        t.integer :position
        t.datetime :deleted_at
        t.timestamps null: false
      end

      add_index :hd_anticoagulants, :code, unique: true
      add_index :hd_anticoagulants, :deleted_at

      seed_default_anticoagulants
      seed_legacy_profile_anticoagulants
    end
  end

  def down
    within_renalware_schema do
      drop_table :hd_anticoagulants
    end
  end

  private

  def seed_default_anticoagulants
    safety_assured do
      DEFAULT_ANTICOAGULANTS.each.with_index(1) do |(code, name), position|
        execute <<~SQL.squish
          INSERT INTO renalware.hd_anticoagulants
            (code, name, position, created_at, updated_at)
          VALUES
            ('#{code}', '#{name}', #{position}, current_timestamp, current_timestamp)
          ON CONFLICT (code) DO NOTHING
        SQL
      end
    end
  end

  def seed_legacy_profile_anticoagulants
    safety_assured do
      execute <<~SQL.squish
        INSERT INTO renalware.hd_anticoagulants
          (code, name, created_at, updated_at)
        SELECT DISTINCT
          anticoagulant_code,
          initcap(replace(anticoagulant_code, '_', ' ')),
          current_timestamp,
          current_timestamp
        FROM (
          SELECT document #>> '{anticoagulant,type}' AS anticoagulant_code
          FROM renalware.hd_profiles
        ) profiles
        WHERE anticoagulant_code IS NOT NULL
          AND anticoagulant_code <> ''
        ON CONFLICT (code) DO NOTHING
      SQL
    end
  end
end
