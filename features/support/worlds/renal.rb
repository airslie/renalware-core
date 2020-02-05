# frozen_string_literal: true

module World
  module Renal
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/renal/*.rb")].sort.each { |f| require f }
