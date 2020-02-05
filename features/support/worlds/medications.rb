# frozen_string_literal: true

module World
  module Medications
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/medications/*.rb")]
  .sort.each { |f| require f }
