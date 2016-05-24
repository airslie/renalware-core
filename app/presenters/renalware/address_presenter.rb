require_dependency "renalware"

module Renalware
  class AddressPresenter < SimpleDelegator
    def on_one_line
      to_s
    end

    def short
      [street_1, postcode].reject(&:blank?).join(", ")
    end
  end
end
