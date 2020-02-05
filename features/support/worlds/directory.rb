# frozen_string_literal: true

module World
  module Directory
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/directory/*.rb")]
  .sort.each { |f| require f }
