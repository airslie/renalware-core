class AddApplicationUrlToResearchStudies < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :research_studies, :application_url, :string, null: true
    end
  end
end
