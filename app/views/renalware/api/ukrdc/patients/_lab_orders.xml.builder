xml = builder

xml.LabOrders(start: Time.zone.today.iso8601, stop: Time.zone.today.iso8601) do
  xml.comment! "Check what start and stop refer to here"
  xml.comment! "TODO"
end
