class CreateHeroicMriScansView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      create_view :mri_scans
    end
  end
end
