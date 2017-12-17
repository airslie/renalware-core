class AddPathologyObservationSetToLetters < ActiveRecord::Migration[5.1]
  def change
    add_column :letter_letters,
               :pathology_snapshot,
               :jsonb,
               index: { using: :gin },
               default: {},
               null: false
  end
end
