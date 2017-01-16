require_dependency "renalware"
require_dependency "renalware/address_presenter/single_line"

module Renalware
  class PatientPresenter < SimpleDelegator
    def address
      AddressPresenter::SingleLine.new(current_address)
    end

    def to_s(format: :long)
      super(format)
    end

    def nhs_number
      return unless super.present? && super.length >= 10
      return if super.index(" ")
      "#{super[0..2]} #{super[3..5]} #{super[6..-1]}"
    end
  end
end
