module Renalware
  module Patients
    module Ingestion
      describe Command do
        describe ".for" do
          it "delegates to CommandFactory#for" do
            message = double(
              :message,
              type: :update_person_information,
              has_assigned_location?: false
            )

            factory = instance_double(CommandFactory, for: nil)
            allow(CommandFactory).to receive(:new).and_return(factory)

            described_class.for(message)

            expect(factory).to have_received(:for).with(message)
          end
        end
      end
    end
  end
end
