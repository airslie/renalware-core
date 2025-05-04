class CreateHelpTours < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :help_tour_pages do |t|
        t.string :name
        t.string :route, null: false
        t.index "lower(route)", unique: true
        t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
      end

      create_table :help_tour_annotations do |t|
        t.references :page, null: false, foreign_key: { to_table: :help_tour_pages }
        t.integer :position, null: false, default: 1
        t.string :title
        t.string :text, null: false
        t.string :attached_to_selector, null: false
        t.string :attached_to_position, null: false, default: "bottom"
        t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
        t.index %i(page_id attached_to_selector), unique: true
      end
    end
  end
end
