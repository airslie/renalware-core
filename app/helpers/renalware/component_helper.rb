module Renalware::ComponentHelper
  def render_toggled_cell(record)
    class_parts = record.class.name.split("::")
    class_name = class_parts.pop
    class_parts << "Detail" << class_name
    render class_parts.join("::").constantize.new(record)
  end
end
