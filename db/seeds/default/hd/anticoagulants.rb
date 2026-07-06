require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding HD Anticoagulants" do
    {
      none: "None",
      heparin: "Heparin",
      enoxyparin: "Enoxaparin",
      warfarin: "Warfarin",
      tinzaparin: "Tinzaparin"
    }.each.with_index(1) do |(code, name), position|
      HD::Anticoagulant.find_or_create_by!(code:) do |anticoagulant|
        anticoagulant.name = name
        anticoagulant.position = position
      end
    end
  end
end
