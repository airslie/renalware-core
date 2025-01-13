class AddConsultantCodeToAdmissionAdmissions < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      add_column :admission_admissions, :consultant_code, :string
    end
  end
end
