class CreateHeroicBloodVisitsView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      create_view :blood_visits
    end
  end
end
