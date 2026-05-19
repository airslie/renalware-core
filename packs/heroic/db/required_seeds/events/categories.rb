# frozen_string_literal: true

module Renalware::Heroic
  Rails.benchmark "Adding Heroic Event Categories" do
    Renalware::Events::Category.find_or_create_by!(name: "HEROIC Events")
    Renalware::Events::Category.find_or_create_by!(name: "HEROIC Investigations")
  end
end
