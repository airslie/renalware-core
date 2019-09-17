class AddPriorityToAdmissionConsults < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :admission_consults, :priority, :integer, null: true
      add_index :admission_consults, :priority
    end
  end
end
