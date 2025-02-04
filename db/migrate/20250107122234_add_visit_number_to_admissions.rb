class AddVisitNumberToAdmissions < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :admission_admissions, :visit_number, :text, null: true
        add_index :admission_admissions, :visit_number
      end
    end
  end
end
