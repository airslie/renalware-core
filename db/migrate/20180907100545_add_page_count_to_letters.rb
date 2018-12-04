class AddPageCountToLetters < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :letter_letters, :page_count, :integer
    end
  end
end
