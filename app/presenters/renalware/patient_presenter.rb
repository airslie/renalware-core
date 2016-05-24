require_dependency "renalware"

module Renalware
  class PatientPresenter < SimpleDelegator
    def address_line
      return if current_address.blank?

      ::Renalware::AddressSingleLinePresenter.new(current_address)
    end

    def to_s
      super(:long)
    end
  end
end
