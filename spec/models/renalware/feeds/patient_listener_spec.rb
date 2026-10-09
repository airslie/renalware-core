module Renalware
  module Feeds
    describe PatientListener do
      describe "#patient_added" do
        it "delegates to another object to replay (and thus import) historical pathology" do
          patient = nil

          expect { described_class.new.patient_added(patient, "bla") }
            .to have_enqueued_job(ReplayHistoricalHL7PathologyMessagesJob).with(patient, "bla")
        end

        context "when replaying pathology messages is disabled via config/ENV var" do
          it "skips the replay" do
            allow(Renalware.config)
              .to receive(:replay_historical_pathology_when_new_patient_added)
              .and_return(false)

            patient = nil

            expect { described_class.new.patient_added(patient, "bla") }
              .not_to have_enqueued_job(ReplayHistoricalHL7PathologyMessagesJob)
          end
        end
      end
    end
  end
end
