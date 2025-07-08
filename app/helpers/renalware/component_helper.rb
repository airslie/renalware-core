module Renalware::ComponentHelper
  # Work out the component class name from the model class
  # e.g. Renalware::Events::SimpleEvent -> Renalware::Events::Detail::SimpleEvent
  def render_toggled_cell(record)
    class_parts = record.class.name.split("::")
    class_name = class_parts.pop
    class_parts << "Detail" << class_name
    render class_parts.join("::").constantize.new(record)
  end
end
