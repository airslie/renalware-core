# frozen_string_literal: true

module Renalware
  log "Adding Default Event Categories" do
    Events::Category.find_or_create_by!(name: "General") do |category|
      category.position = 1
    end
  end
end
