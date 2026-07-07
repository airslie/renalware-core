# frozen_string_literal: true

class CreateLegacyLetters < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      adopt_blt_legacy_table(:legacy_letter_authors)
      adopt_blt_legacy_table(:legacy_letters)

      create_legacy_letter_authors
      create_legacy_letters
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
          "Legacy letter tables may contain adopted BLT archive data; rollback must be manual."
  end

  private

  def create_legacy_letter_authors
    return if table_exists?(:legacy_letter_authors)

    # BLT's existing legacy_letter_authors table has no timestamps; keep fresh installs aligned.
    # rubocop:disable Rails/CreateTableWithTimestamps
    create_table :legacy_letter_authors do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :code
    end
    # rubocop:enable Rails/CreateTableWithTimestamps
  end

  def create_legacy_letters
    return if table_exists?(:legacy_letters)

    create_table :legacy_letters do |t|
      t.integer :legacy_id, index: true, null: false
      t.references :patient, foreign_key: { to_table: :patients }, index: true, null: false
      t.string :letter_site, index: true
      t.string :hospital_no
      t.datetime :archived_at
      t.references :authored_by, foreign_key: { to_table: :users }, index: true
      t.date :clinic_date
      t.date :letter_date, index: true
      t.text :letter_description, index: true
      t.string :recipient_name, index: true
      t.text :letter_html
      t.references :legacy_letter_author,
                   index: true,
                   null: true,
                   foreign_key: true

      t.timestamps null: false
    end
  end

  def adopt_blt_legacy_table(table_name)
    renalware_table = qualified_table_name(:renalware, table_name)
    blt_table = qualified_table_name(:renalware_blt, table_name)

    return unless relation_exists?(blt_table)
    return move_blt_table_to_renalware(table_name) unless relation_exists?(renalware_table)

    raise <<~MESSAGE.squish
      Both #{renalware_table} and #{blt_table} exist. Resolve this manually before running this
      migration, otherwise Renalware could read from the wrong legacy letter table.
    MESSAGE
  end

  def move_blt_table_to_renalware(table_name)
    safety_assured do
      execute("ALTER TABLE #{qualified_table_name(:renalware_blt, table_name)} SET SCHEMA renalware")
    end
  end

  def relation_exists?(qualified_table_name)
    select_value("SELECT to_regclass(#{connection.quote(qualified_table_name)})::text").present?
  end

  def qualified_table_name(schema, table_name)
    "#{schema}.#{table_name}"
  end
end
