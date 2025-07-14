module Renalware::ComponentHelper
  # Work out the component class name from the model class
  # e.g. Renalware::Events::SimpleEvent -> Renalware::Events::SimpleEvent::Detail
  def render_toggled_cell(record)
    render "#{record.class.name}::Detail".constantize.new(record)
  end
end
