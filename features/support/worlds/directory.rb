module World
  module Directory
  end
end

Dir[Rails.root.join("features/support/worlds/directory/*.rb")].each { |f| require f }
