class AddIncludePathologyInLetterToLettersLetterheads < ActiveRecord::Migration[5.1]
  def change
    add_column :letter_letterheads, :include_pathology_in_letter_body, :boolean, default: true
  end
end
