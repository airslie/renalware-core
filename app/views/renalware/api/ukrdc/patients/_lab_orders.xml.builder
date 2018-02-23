xml = builder

# TODO: Implement start stop dates
xml.LabOrders(start: patient.changes_since.iso8601, stop: patient.changes_up_until.iso8601) do
  render partial: "renalware/api/ukrdc/patients/lab_orders/lab_order",
         collection: patient.observation_requests.includes(
           :description,
           observations: { description: :measurement_unit }
         ),
         as: :request,
         locals: { builder: builder, patient: patient }
end
