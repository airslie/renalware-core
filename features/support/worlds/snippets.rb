module World
  module Snippets
    def snippets_user(user)
      Renalware::Snippets.cast_user(user)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/snippets/*.rb")].each { |f| require f }
