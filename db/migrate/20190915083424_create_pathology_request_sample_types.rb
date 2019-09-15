class CreatePathologyRequestSampleTypes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :pathology_requests_sample_types do |t|
        t.string :name, index: { unique: true }, null: false
        t.string :code, index: { unique: true }, null: false
        t.timestamps null: false
      end
    end
  end
end
