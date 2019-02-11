# frozen_string_literal: true

module Renalware
  log "Adding HD Providers" do
    HD::Provider.find_or_create_by!(name: "Diaverum")
    HD::Provider.find_or_create_by!(name: "Fresenius")
  end
end
