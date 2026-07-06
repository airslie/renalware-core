require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding blood group descriptions" do
    {
      "A" => { name: "A", position: 1 },
      "AB" => { name: "AB", position: 2 },
      "B" => { name: "B", position: 3 },
      "O" => { name: "O", position: 4 }
    }.each do |code, attributes|
      BloodGroupDescription.find_or_create_by!(code:) do |description|
        description.name = attributes.fetch(:name)
        description.position = attributes.fetch(:position)
      end
    end
  end
end
