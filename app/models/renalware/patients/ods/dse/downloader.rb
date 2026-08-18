require "faraday"
require "tempfile"

module Renalware
  module Patients
    module ODS
      module DSE
        class Downloader
          BASE_URL = "https://www.odsdatasearchandexport.nhs.uk/api/getReport".freeze

          def initialize(connection: nil)
            @connection = connection || Faraday.new(request: { open_timeout: 15, timeout: 180 })
          end

          def call(report_name)
            response = connection.get(BASE_URL, report: report_name)
            validate_response!(response, report_name)

            Tempfile.new([report_name, ".csv"]).tap do |file|
              file.binmode
              file.write(response.body)
              file.flush
              file.rewind
            end
          rescue Faraday::Error => e
            raise DownloadError, "Could not download ODS DSE report #{report_name}: #{e.message}"
          end

          private

          attr_reader :connection

          def validate_response!(response, report_name)
            unless response.success?
              raise DownloadError,
                    "ODS DSE report #{report_name} returned HTTP #{response.status}"
            end

            content_type = response.headers["content-type"].to_s
            return if content_type.start_with?("text/csv")

            raise DownloadError,
                  "ODS DSE report #{report_name} returned unexpected content type " \
                  "#{content_type.inspect}"
          end
        end
      end
    end
  end
end
