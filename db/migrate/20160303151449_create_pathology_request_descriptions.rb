class CreatePathologyRequestDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_request_descriptions do |t|
      t.string :code, null: false
    end
  end
end
