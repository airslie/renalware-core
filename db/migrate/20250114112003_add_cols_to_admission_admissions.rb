class AddColsToAdmissionAdmissions < ActiveRecord::Migration[7.2]
  def change
    within_renalware_schema do
      add_column :admission_admissions, :room, :string
      add_column :admission_admissions, :bed, :string
      add_column :admission_admissions, :building, :string
      add_column :admission_admissions, :floor, :string
    end
  end
end
