class AddPartialIndexToClinicsCode < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      # Replace index on clinic_clinics.code so that it's unique
      # only when deleted_at is null, so that it's possible to add a clinic with the same
      # code as one that has been soft deleted. The alternative is to allow a user
      # to reinstate a deleted clinic, but we are going this way for now!
      remove_index(:clinic_clinics, :code)
      add_index(:clinic_clinics, :code, unique: true, where: "deleted_at IS NULL")
    end
  end
end
