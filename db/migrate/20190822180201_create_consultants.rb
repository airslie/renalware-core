# rubocop:disable Rails/CreateTableWithTimestamps
class CreateConsultants < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :renal_consultants do |t|
        t.string :code, index: { unique: true }, null: false
        t.string :name
      end
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
