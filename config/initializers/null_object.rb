module Renalware
  NullObject = Naught.build do |config|
    config.black_hole
    config.define_explicit_conversions
    config.singleton
    # Note adding `predicates_return false` causes failures e.g. with I18n.l(<null>)
    # config.predicates_return false
  end
end
