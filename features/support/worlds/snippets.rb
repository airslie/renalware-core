# frozen_string_literal: true

module World
  module Snippeting
    def snippets_user(user)
      Renalware::Snippeting.cast_user(user)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/snippets/*.rb")].each { |f| require f }
