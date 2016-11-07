module Renalware
  NullObject = Naught.build do |config|
    config.black_hole
    config.define_explicit_conversions
    config.singleton
  end
end
