class CreateHDProfileForModalites < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :hd_profile_for_modalities
    end
  end
end
