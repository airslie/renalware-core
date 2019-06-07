# frozen_string_literal: true

xml = builder

xml.Encounters do
  render "treatments", builder: xml, patient: patient
end
