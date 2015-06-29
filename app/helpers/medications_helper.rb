module MedicationsHelper

  def display_med_field(med_object, assoc, method)
    if med_object.persisted? || med_object.changed.include?('medicatable_id')
      assoc.send(method)
    else
      return nil
    end
  end

  def validation_highlight(med_object, med_attribute)
    if med_object.errors.include?(med_attribute)
      'field_with_errors'
    else
      nil
    end
  end

  def show_validation_fail(med_object, tag, default_tag)
    med_object.errors.any? ? tag : default_tag
  end

  def default_provider(provider)
    provider == 'gp' ? 'checked' : nil
  end

end