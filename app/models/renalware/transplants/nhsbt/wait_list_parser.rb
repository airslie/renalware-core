require "csv"

module Renalware
  module Transplants
    module NHSBT
      class WaitListParser
        REQUIRED_HEADERS = [
          "RECIP ID",
          "DATE OF BIRTH",
          "KIDNEY STATUS",
          "KIDNEY STATUS DATE",
          "TISSUE TYPE",
          "MATCH SCORE",
          "MATCH POINTS",
          "CRF",
          "SENSI EVAL DATE",
          "KIDNEY WAITING TIME (days)",
          "PANCREAS WAITING TIME (days)"
        ].freeze

        Row = Data.define(
          :recip_id,
          :date_of_birth,
          :kidney_status,
          :kidney_status_date,
          :tissue_type,
          :match_score,
          :match_points,
          :crf,
          :sensi_eval_date,
          :kidney_waiting_time_days,
          :pancreas_waiting_time_days
        )

        def initialize(path)
          @path = path
        end

        def call
          rows = []
          headers = nil

          CSV.foreach(path, headers: false).with_index(1) do |csv_row, line_number|
            headers = process_csv_row(csv_row, line_number, headers, rows)
          end

          rows
        end

        private

        attr_reader :path

        def process_csv_row(csv_row, line_number, headers, rows)
          values = csv_row.to_a.map { |value| value.to_s.strip }
          return headers if blank_row?(values)

          if headers.nil? || header_row?(values)
            validate_headers!(values)
            return values
          end

          rows << build_row(headers, values, line_number)
          headers
        end

        def blank_row?(values) = values.all?(&:blank?)

        def header_row?(values) = values.first == REQUIRED_HEADERS.first

        def validate_headers!(headers)
          missing_headers = REQUIRED_HEADERS - headers
          return if missing_headers.none?

          raise InvalidCSV, "Missing required columns: #{missing_headers.join(', ')}"
        end

        def build_row(headers, values, line_number)
          row = headers.zip(values).to_h

          Row.new(**row_attributes(row, line_number))
        end

        def row_attributes(row, line_number)
          {
            recip_id: fetch_value(row, "RECIP ID", line_number),
            date_of_birth: parse_row_date(row, "DATE OF BIRTH", line_number),
            kidney_status: fetch_value(row, "KIDNEY STATUS", line_number),
            kidney_status_date: parse_row_date(row, "KIDNEY STATUS DATE", line_number),
            tissue_type: fetch_value(row, "TISSUE TYPE", line_number),
            crf: fetch_value(row, "CRF", line_number),
            sensi_eval_date: parse_row_date(row, "SENSI EVAL DATE", line_number)
          }.merge(match_attributes(row, line_number), waiting_time_attributes(row, line_number))
        end

        def match_attributes(row, line_number)
          {
            match_score: fetch_value(row, "MATCH SCORE", line_number),
            match_points: fetch_value(row, "MATCH POINTS", line_number)
          }
        end

        def waiting_time_attributes(row, line_number)
          {
            kidney_waiting_time_days: fetch_value(row, "KIDNEY WAITING TIME (days)", line_number),
            pancreas_waiting_time_days: row.fetch("PANCREAS WAITING TIME (days)").presence
          }
        end

        def parse_row_date(row, header, line_number)
          parse_date(fetch_value(row, header, line_number), line_number)
        end

        def fetch_value(row, header, line_number)
          row.fetch(header).presence ||
            raise(InvalidCSV, "#{header} is blank on line #{line_number}")
        end

        def parse_date(value, line_number)
          Date.strptime(value, "%d/%m/%Y")
        rescue Date::Error
          raise InvalidCSV, "Invalid UK date '#{value}' on line #{line_number}; expected dd/mm/yyyy"
        end

        class InvalidCSV < StandardError; end
      end
    end
  end
end
