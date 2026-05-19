# frozen_string_literal: true

module Renalware::Heroic
  Rails.benchmark "Adding Heroic Event Types" do
    file_path = File.join(File.dirname(__FILE__), "types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      category = Renalware::Events::Category.find_by!(name: row["category_name"])
      Renalware::Events::Type.find_or_create_by!(
        name: row["name"],
        event_class_name: row["event_class_name"],
        category: category
      )
    end
  end
end
