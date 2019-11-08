class AddNamedConsultantToPatients < ActiveRecord::Migration[5.2]
  def change
    add_reference(
      :patients,
      :named_consultant,
      foreign_key: { to_table: :users },
      index: true,
      null: true
    )
  end
end
