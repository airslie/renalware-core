# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding Roles" do
    Role.install!
  end
end
