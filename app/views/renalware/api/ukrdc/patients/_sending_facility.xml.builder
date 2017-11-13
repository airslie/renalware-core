xml = builder

xml.SendingFacility(
  channelName: "Renalware",
  time: Time.zone.now.to_datetime) do
end
xml.SendingExtract "UKRDC"
