# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding Default Event Categories" do
    Events::Category.find_or_create_by!(name: "General") do |category|
      category.position = 1
    end
  end
end
