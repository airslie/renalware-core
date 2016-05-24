module Renalware
  module DoctorsHelper
    def practices_options_for_select(doctor)
      selected_ids = doctor.practices.map(&:id)
      options_from_collection_for_select(Practice.all, :id, :name, selected_ids)
    end

    def practices_or_address(doctor)
      return practices_list(doctor.practices) if doctor.practices.any?
      return format_address(doctor.address) if doctor.address.present?
    end

    private

    def format_address(address)
      ::Renalware::AddressPresenter::Short.new(address)
    end

    def practices_list(practices)
      practice_links = practices.map { |p| link_to(p.name, '#', title: format_address(p.address)) }
      practice_links.join(tag(:br)).html_safe
    end
  end
end
