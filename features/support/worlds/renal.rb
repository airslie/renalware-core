module World
  module Renal
  end
end

Dir[Rails.root.join("features/support/worlds/renal/*.rb")].each { |f| require f }
