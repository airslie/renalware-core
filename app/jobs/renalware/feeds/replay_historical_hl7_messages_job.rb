# frozen_string_literal: true

# 'patient_added' event...
#   -> Renalware::Feeds::PatientListener receives the event
#     -> ReplayHistoricalHL7MessagesJob.perform_later(patient) # async so main thread not held up
#       -> ReplayHistoricalHL7Messages.call(patient: patient) # does the heavy lifting
#         -> for each replayable path message fetched via ReplayableHL7PathologyMessagesQuery
#           -> broadcast oru_message_arrived event
#             -> Renalware::Patients::Ingestion::MessageListener
#             -> Renalware::Pathology::Ingestion::AKIListener
#             -> Renalware::Pathology::Ingestion::MessageListener
#             -> Renalware::Clinics::Ingestion::MessageListener
#             -> Renalware::Pathology::KFRE::Listener
#             -> ... extensible list
module Renalware
  module Feeds
    class ReplayHistoricalHL7MessagesJob
      def perform
        ReplayHistoricalHL7Messages.call(patient: patient)
      end
    end
  end
end
