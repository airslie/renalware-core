module MedicationsHelper

  def display_med_field(med_object, assoc, method)
    if med_object.persisted? || med_object.changed.include?('medicatable_id')
      assoc.send(method)
    else
      return nil
    end
  end

end