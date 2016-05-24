require_dependency "renalware"

module Renalware
  class AddressPresenter < SimpleDelegator
    def on_one_line
      to_s
    end
  end
end
