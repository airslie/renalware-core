module Renalware
  module Patients
    describe SyncGpsViaFileDownloadJob do
      it "downloads and imports each configured ODS file" do
        job = described_class.new
        file_type = instance_double(Feeds::FileType)
        feed_file = instance_double(Feeds::File, file_type:)
        import_job = class_double(ApplicationJob, perform_now: nil)
        allow(job).to receive_messages(system: true, create_feed_file: feed_file)
        allow(Feeds::Files::ImportJobFactory).to receive(:job_class_for).and_return(import_job)

        job.perform

        described_class::ODS_DOWNLOADABLES.each_value do |options|
          expect(job).to have_received(:system).with(
            "wget",
            "-O",
            kind_of(String),
            options.fetch(:url)
          )
        end
        expect(import_job).to have_received(:perform_now).with(feed_file).twice
      end
    end
  end
end
