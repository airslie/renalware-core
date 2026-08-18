module Renalware
  module Patients
    module ODS
      module DSE
        describe Downloader do
          let(:stubs) { Faraday::Adapter::Test::Stubs.new }
          let(:connection) { Faraday.new { it.adapter(:test, stubs) } }

          it "downloads a CSV report to a tempfile" do
            stubs.get("/api/getReport?report=egpcur") do
              [200, { "Content-Type" => "text/csv" }, "one,two\n"]
            end

            file = described_class.new(connection:).call("egpcur")

            expect(file.read).to eq("one,two\n")
          ensure
            file&.close!
            stubs.verify_stubbed_calls
          end

          it "rejects unsuccessful responses" do
            stubs.get("/api/getReport?report=egpcur") { [503, {}, "Unavailable"] }

            expect {
              described_class.new(connection:).call("egpcur")
            }.to raise_error(DownloadError, /HTTP 503/)
          end

          it "rejects non-CSV responses" do
            stubs.get("/api/getReport?report=egpcur") do
              [200, { "Content-Type" => "text/html" }, "<html></html>"]
            end

            expect {
              described_class.new(connection:).call("egpcur")
            }.to raise_error(DownloadError, /unexpected content type/)
          end
        end
      end
    end
  end
end
