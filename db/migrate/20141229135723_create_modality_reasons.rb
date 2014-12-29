class CreateModalityReasons < ActiveRecord::Migration
  def change
    create_table :modality_reasons do |t|

      t.timestamps
    end
  end
end
