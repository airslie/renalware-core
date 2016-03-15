class CreatePathologyRequestDescriptions < ActiveRecord::Migration
  def change
    create_table :pathology_request_descriptions do |t|
      t.string :code, null: false
    end
  end
end
