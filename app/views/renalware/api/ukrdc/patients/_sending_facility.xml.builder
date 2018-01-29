xml = builder

xml.SendingFacility Renalware.config.ukrdc_sending_facility_name,
                    channelName: "Renalware",
                    time: Time.zone.now.to_datetime

xml.SendingExtract "UKRDC"
