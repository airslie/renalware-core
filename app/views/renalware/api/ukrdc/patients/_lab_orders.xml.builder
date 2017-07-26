xml = builder

xml.LabOrders(start: Time.zone.today.iso8601, stop: Time.zone.today.iso8601) do
  xml.comment! "TODO: start and stop date"

  render partial: "renalware/api/ukrdc/patients/lab_orders/lab_order",
       collection: patient.observation_requests,
       as: :request,
       locals: { builder: builder }
end
