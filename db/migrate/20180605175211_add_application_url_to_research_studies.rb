class AddApplicationUrlToResearchStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :research_studies, :application_url, :string, null: true
  end
end
