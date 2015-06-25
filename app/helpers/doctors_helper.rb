module DoctorsHelper
  def practices_options_for_select(doctor)
    selected_ids = doctor.practices.map(&:id)
    options_from_collection_for_select(Practice.all, :id, :name, selected_ids)
  end

  def address_or_practices(doctor)
    if doctor.practices.any?
      practices_list(doctor.practices)
    elsif doctor.address.present?
      doctor.address
    else
      'N/A'
    end
  end

  def practices_list(practices)
    practice_links = practices.map { |p| link_to(p.name, '#') }
    practice_links.join(tag(:br)).html_safe
  end
end
