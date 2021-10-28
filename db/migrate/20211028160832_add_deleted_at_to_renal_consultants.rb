class AddDeletedAtToRenalConsultants < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_table :renal_consultants do |t|
        t.datetime :renal_consultants, :deleted_at, index: true
        t.references :updated_by, foreign_key: { to_table: :users }, index: true
        t.references :created_by, foreign_key: { to_table: :users }, index: true

        # Replace code and name indexes on renal_consultants so that they are unique
        # only when deleted is null, so that it is possible to add a consultant with the same
        # name and code as one that has been soft deleted. The alternative is to allow a user
        # to reinstate a deleted consultant, but we are going this way for now!
        remove_index(:renal_consultants, :name)
        add_index(:renal_consultants, :name, unique: true, where: "deleted_at IS NULL")
        add_index(:renal_consultants, :code, unique: true, where: "deleted_at IS NULL")
      end
    end
  end
end
