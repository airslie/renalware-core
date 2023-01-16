# frozen_string_literal: true

module Renalware
  log "Death locations" do
    %w(Home Hospital Hospice Abroad Other).each do |name|
      Deaths::Location.create!(name: name)
    end
  end
end
